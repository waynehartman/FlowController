//
//  WHLinearCarSelectionFlowController.m
//  FlowControllerDemo
//
//  Created by Wayne Hartman on 7/6/15.
//  Copyright (c) 2015 Wayne Hartman. All rights reserved.
//

#import "WHLinearCarSelectionFlowController.h"
#import "WHNetworkController.h"
#import "WHConfirmationViewController.h"
#import "WHSelectionViewController.h"
#import "WHActivityView.h"

@interface WHLinearCarSelectionFlowController () <WHConfirmationViewControllerDelegate, WHSelectionViewControllerDelegate>

@property (nonatomic, strong) WHSelectionViewController *yearSelectionViewController;
@property (nonatomic, weak) WHSelectionViewController *makeSelectionViewController;
@property (nonatomic, weak) WHSelectionViewController *modelSelectionViewController;
@property (nonatomic, weak) WHConfirmationViewController *confirmationVC;

@end

@implementation WHLinearCarSelectionFlowController

- (WHSelectionViewController *)yearSelectionViewController {
    if (!_yearSelectionViewController) {
        _yearSelectionViewController = [[WHSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
        _yearSelectionViewController.delegate = self;
        _yearSelectionViewController.title = @"Year";
        
        [_yearSelectionViewController setRefreshActive:YES];
        
        __weak typeof(self) weakSelf = self;
        
        WHNetworkController *networkController = [[WHNetworkController alloc] init];
        [networkController fetchYearsWithCompletion:^(id responseObject, NSError *error) {
            if (error) {
                [weakSelf handleNetworkError:error];
            } else {
                weakSelf.yearSelectionViewController.list = responseObject;
            }

            [weakSelf.yearSelectionViewController setRefreshActive:NO];
        }];
    }

    return _yearSelectionViewController;
}

- (void)handleNetworkError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Unable to get data."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];

    [self.navController presentViewController:alert animated:YES completion:NULL];
}

- (UIViewController *)initialViewController {
    return self.yearSelectionViewController;
}

#pragma mark - WHSelectionViewControllerDelegate

- (void)selectionViewController:(WHSelectionViewController *)selectionViewController didSelectModelObject:(id)object
{
    UIViewController *nextViewController = nil;

    if (selectionViewController == self.yearSelectionViewController) {
        WHSelectionViewController *makeVC = [[WHSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
        makeVC.delegate = self;
        makeVC.title = @"Make";

        nextViewController = makeVC;
        [makeVC setRefreshActive:YES];

        __weak typeof(self) weakSelf = self;

        WHNetworkController *networkController = [[WHNetworkController alloc] init];
        [networkController fetchMakesForYear:self.yearSelectionViewController.selectedListItem withCompletion:^(id responseObject, NSError *error)
        {
            if (error) {
                [weakSelf handleNetworkError:error];
            } else {
                weakSelf.makeSelectionViewController.list = responseObject;
            }

            [weakSelf.makeSelectionViewController setRefreshActive:NO];
        }];

        self.makeSelectionViewController = makeVC;
    } else if (selectionViewController == self.makeSelectionViewController) {
        WHSelectionViewController *modelVC = [[WHSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
        modelVC.delegate = self;
        modelVC.title = @"Model";
        
        self.modelSelectionViewController = modelVC;
        
        __weak typeof(self) weakSelf = self;
        
        WHNetworkController *networkController = [[WHNetworkController alloc] init];
        [networkController fetchModelsForYear:self.yearSelectionViewController.selectedListItem make:self.makeSelectionViewController.selectedListItem withCompletion:^(id responseObject, NSError *error)
        {
            if (error) {
                [weakSelf handleNetworkError:error];
            } else {
                weakSelf.modelSelectionViewController.list = responseObject;
            }
            
            [weakSelf.modelSelectionViewController setRefreshActive:NO];
        }];
        
        nextViewController = modelVC;
        [modelVC setRefreshActive:YES];
    } else if (selectionViewController == self.modelSelectionViewController) {
        WHConfirmationViewController *confirmationVC = self.confirmationVC;

        if (!confirmationVC) {
            confirmationVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WHConfirmationViewController"];
        }

        confirmationVC.delegate = self;
        confirmationVC.year = self.yearSelectionViewController.selectedListItem;
        confirmationVC.make = self.makeSelectionViewController.selectedListItem;
        confirmationVC.model = self.modelSelectionViewController.selectedListItem;

        nextViewController = confirmationVC;
    }
    
    [self.navController pushViewController:nextViewController animated:YES];
    
}

- (void)selectionViewController:(WHSelectionViewController *)selectionViewController didSelectRefreshWithRefreshHandler:(WHSelectionViewControllerRefreshHandler)refreshHandler {
    
}

#pragma mark - WHConfirmationViewControllerDelegate

- (void)confirmationViewControllerDidSelectConfirm:(WHConfirmationViewController *)confirmationVC {
    WHActivityView *activityView = [[WHActivityView alloc] initWithFrame:self.navController.view.bounds];

    [self.navController.view addSubview:activityView];

    __weak typeof(self) weakSelf = self;
    
    WHNetworkController *networkController = [[WHNetworkController alloc] init];
    [networkController orderVehicleWithYear:confirmationVC.year make:confirmationVC.make model:confirmationVC.model withCompletion:^(id responseObject, NSError *error)
    {
        UIAlertAction *action = nil;
        NSString *title = nil;
        NSString *message = nil;
        
        if (!error) {
            title = @"Success!!";
            message = @"Your car has been ordered!";
            action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self.navController popToRootViewControllerAnimated:YES];
            }];
        } else {
            title = @"Error";
            message = @"There was an error ordering your car. Please try again later";
            action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //   DO NOTHING
            }];
        }
        
        [UIView animateWithDuration:0.33 animations:^{
            activityView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [activityView removeFromSuperview];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:action];
            [weakSelf.navController presentViewController:alertController animated:YES completion:NULL];

            weakSelf.yearSelectionViewController.selectedListItem = nil;
        }];
    }];
}

- (void)confirmationViewController:(WHConfirmationViewController *)confirmationVC didSelectSelectionType:(WHConfirmationSelectionType)selectionType {
    //  DO NOTHING
}

@end

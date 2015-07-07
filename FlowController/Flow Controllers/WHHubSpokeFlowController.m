/*
 
 Copyright (c) 2015, Wayne Hartman
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

#import "WHHubSpokeFlowController.h"
#import "WHNetworkController.h"
#import "WHConfirmationViewController.h"
#import "WHSelectionViewController.h"
#import "WHActivityView.h"

@interface WHHubSpokeFlowController () <WHConfirmationViewControllerDelegate, WHSelectionViewControllerDelegate>

@property (nonatomic, weak) WHSelectionViewController *yearSelectionViewController;
@property (nonatomic, weak) WHSelectionViewController *makeSelectionViewController;
@property (nonatomic, weak) WHSelectionViewController *modelSelectionViewController;
@property (nonatomic, strong) WHConfirmationViewController *confirmationVC;

@end

@implementation WHHubSpokeFlowController

- (void)handleNetworkError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Unable to get data."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
    
    [self.navController presentViewController:alert animated:YES completion:NULL];
}

- (UIViewController *)initialViewController {
    if (!_confirmationVC) {
        WHConfirmationViewController *confirmationVC = self.confirmationVC;
        
        if (!confirmationVC) {
            confirmationVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WHConfirmationViewController"];
            confirmationVC.title = @"Select A Car";
        }
        
        confirmationVC.delegate = self;

        _confirmationVC = confirmationVC;
    }
    
    return self.confirmationVC;
}

#pragma mark - WHSelectionViewControllerDelegate

- (void)selectionViewController:(WHSelectionViewController *)selectionViewController didSelectModelObject:(id)object
{
    if (selectionViewController == self.yearSelectionViewController) {
        self.confirmationVC.year = object;
    } else if (selectionViewController == self.makeSelectionViewController) {
        self.confirmationVC.make = object;
    } else if (selectionViewController == self.modelSelectionViewController) {
        self.confirmationVC.model = object;
    }
    
    [self.navController popToViewController:self.confirmationVC animated:YES];
    
}

- (void)selectionViewController:(WHSelectionViewController *)selectionViewController didSelectRefreshWithRefreshHandler:(WHSelectionViewControllerRefreshHandler)refreshHandler {
    
}

#pragma mark - WHConfirmationViewControllerDelegate

- (void)confirmationViewControllerDidSelectConfirm:(WHConfirmationViewController *)confirmationVC {
    WHActivityView *activityView = [[WHActivityView alloc] initWithFrame:self.navController.view.bounds];
    
    [self.navController.view addSubview:activityView];

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
             [confirmationVC presentViewController:alertController animated:YES completion:NULL];

             confirmationVC.year = nil;
             confirmationVC.make = nil;
             confirmationVC.model = nil;
         }];
     }];
}

- (void)confirmationViewController:(WHConfirmationViewController *)confirmationVC didSelectSelectionType:(WHConfirmationSelectionType)selectionType {
    switch (selectionType) {
        case WHConfirmationSelectionTypeYear: {
            WHSelectionViewController *yearSelectionViewController = [[WHSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
            yearSelectionViewController.delegate = self;
            yearSelectionViewController.title = @"Year";
            
            [yearSelectionViewController setRefreshActive:YES];

            self.yearSelectionViewController = yearSelectionViewController;
            
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

            [self.navController pushViewController:yearSelectionViewController animated:YES];
        }
            break;
        case WHConfirmationSelectionTypeMake: {
            if (!confirmationVC.year) {
                return;
            }

            WHSelectionViewController *makeVC = [[WHSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
            makeVC.delegate = self;
            makeVC.title = @"Make";

            [makeVC setRefreshActive:YES];
            
            __weak typeof(self) weakSelf = self;
            
            WHNetworkController *networkController = [[WHNetworkController alloc] init];
            [networkController fetchMakesForYear:self.confirmationVC.year withCompletion:^(id responseObject, NSError *error)
             {
                 if (error) {
                     [weakSelf handleNetworkError:error];
                 } else {
                     weakSelf.makeSelectionViewController.list = responseObject;
                 }
                 
                 [weakSelf.makeSelectionViewController setRefreshActive:NO];
             }];
            
            self.makeSelectionViewController = makeVC;
            
            [self.navController pushViewController:makeVC animated:YES];
        }
            break;
        case WHConfirmationSelectionTypeModel: {
            if (!confirmationVC.year || !confirmationVC.make) {
                return;
            }
            
            WHSelectionViewController *modelVC = [[WHSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
            modelVC.delegate = self;
            modelVC.title = @"Model";
            
            self.modelSelectionViewController = modelVC;
            
            __weak typeof(self) weakSelf = self;
            
            WHNetworkController *networkController = [[WHNetworkController alloc] init];
            [networkController fetchModelsForYear:self.confirmationVC.year make:self.confirmationVC.make withCompletion:^(id responseObject, NSError *error)
             {
                 if (error) {
                     [weakSelf handleNetworkError:error];
                 } else {
                     weakSelf.modelSelectionViewController.list = responseObject;
                 }
                 
                 [weakSelf.modelSelectionViewController setRefreshActive:NO];
             }];

            [modelVC setRefreshActive:YES];
            
            [self.navController pushViewController:modelVC animated:YES];
        }
            break;
    }
}

@end

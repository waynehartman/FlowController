//
//  WHConfirmationViewController.h
//  FlowControllerDemo
//
//  Created by Wayne Hartman on 7/6/15.
//  Copyright (c) 2015 Wayne Hartman. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSInteger, WHConfirmationSelectionType) {
    WHConfirmationSelectionTypeYear = 0,
    WHConfirmationSelectionTypeMake,
    WHConfirmationSelectionTypeModel
};
@protocol WHConfirmationViewControllerDelegate;

@interface WHConfirmationViewController : UITableViewController

@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *make;
@property (nonatomic, strong) NSString *model;

@property (nonatomic, weak) id<WHConfirmationViewControllerDelegate>delegate;

@end



@protocol WHConfirmationViewControllerDelegate <NSObject>

- (void)confirmationViewControllerDidSelectConfirm:(WHConfirmationViewController *)confirmationVC;
- (void)confirmationViewController:(WHConfirmationViewController *)confirmationVC didSelectSelectionType:(WHConfirmationSelectionType)selectionType;

@end

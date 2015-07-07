//
//  WHSelectionViewController.h
//  FlowControllerDemo
//
//  Created by Wayne Hartman on 7/6/15.
//  Copyright (c) 2015 Wayne Hartman. All rights reserved.
//

@import UIKit;

@protocol WHSelectionViewControllerDelegate;
typedef void(^WHSelectionViewControllerRefreshHandler)(NSArray *list, NSError *error);





@interface WHSelectionViewController : UITableViewController

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) id selectedListItem;
@property (nonatomic, weak) id<WHSelectionViewControllerDelegate>delegate;

- (void)setRefreshActive:(BOOL)active;

@end






@protocol WHSelectionViewControllerDelegate <NSObject>

- (void)selectionViewController:(WHSelectionViewController *)selectionViewController didSelectModelObject:(id)object;
- (void)selectionViewController:(WHSelectionViewController *)selectionViewController didSelectRefreshWithRefreshHandler:(WHSelectionViewControllerRefreshHandler)refreshHandler;

@end

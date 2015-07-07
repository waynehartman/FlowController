//
//  WHSelectionViewController.m
//  FlowControllerDemo
//
//  Created by Wayne Hartman on 7/6/15.
//  Copyright (c) 2015 Wayne Hartman. All rights reserved.
//

#import "WHSelectionViewController.h"

@interface WHSelectionViewController ()

@end

NSString  * const cellId = @"CellID";

@implementation WHSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];

    if (!self.refreshControl) {
        [self setupRefreshControl];
    }
}

- (void)setList:(NSArray *)list {
    _list = list;
    
    [self.tableView reloadData];
}

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
    [self.refreshControl addTarget:self
                            action:@selector(didRefresh:)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)didRefresh:(id)sender {
    __weak typeof(self) weakSelf = self;

    [self setRefreshActive:YES];
    [self.delegate selectionViewController:self didSelectRefreshWithRefreshHandler:^(NSArray *list, NSError *error) {
        if (list) {
            weakSelf.list = list;
        }

        [weakSelf setRefreshActive:NO];
    }];
}

- (void)setRefreshActive:(BOOL)active {
    if (!self.refreshControl) {
        [self setupRefreshControl];
    }
    
    if (active) {
        [self.refreshControl beginRefreshing];
    } else {
        [self.refreshControl endRefreshing];
    }
}

- (void)setSelectedListItem:(id)selectedListItem {
    _selectedListItem = selectedListItem;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id listItem = self.list[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = listItem;

    UITableViewCellAccessoryType accessory = UITableViewCellAccessoryNone;

    if (listItem == self.selectedListItem) {
        accessory = UITableViewCellAccessoryCheckmark;
    }

    cell.accessoryType = accessory;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *indexpaths = nil;

    if (self.selectedListItem) {
        id previousObject = self.selectedListItem;

        indexpaths = @[[NSIndexPath indexPathForRow:[self.list indexOfObject:previousObject] inSection:0],
                       [NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    } else {
        indexpaths = @[[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    }

    self.selectedListItem = self.list[indexPath.row];

    [self.tableView reloadRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationNone];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate selectionViewController:self didSelectModelObject:self.selectedListItem];
    });
}

@end

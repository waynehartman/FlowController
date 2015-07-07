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

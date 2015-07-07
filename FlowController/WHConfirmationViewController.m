//
//  WHConfirmationViewController.m
//  FlowControllerDemo
//
//  Created by Wayne Hartman on 7/6/15.
//  Copyright (c) 2015 Wayne Hartman. All rights reserved.
//

#import "WHConfirmationViewController.h"

typedef NS_ENUM(NSInteger, WHConfirmationRow) {
    WHConfirmationRowYear = 0,
    WHConfirmationRowMake,
    WHConfirmationRowModel,
    WHConfirmationRowCount
};

@interface WHConfirmationViewController ()

@property (nonatomic, strong) IBOutlet UILabel *yearLabel;
@property (nonatomic, strong) IBOutlet UILabel *makeLabel;
@property (nonatomic, strong) IBOutlet UILabel *modelLabel;
@property (strong, nonatomic) IBOutlet UIButton *confirmationButton;

@property (nonatomic, strong, readonly) NSString *placeholder;

@end

@implementation WHConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateLabels];
}

- (void)updateLabels {
    NSString *year = self.year;
    NSString *make = self.make;
    NSString *model = self.model;

    if (!year) {
        year = self.placeholder;
    }

    if (!make) {
        make = self.placeholder;
    }

    if (!model) {
        model = self.placeholder;
    }

    self.yearLabel.text = year;
    self.makeLabel.text = make;
    self.modelLabel.text = model;

    self.confirmationButton.enabled = self.year && self.make && self.model;
}

- (NSString *)placeholder {
    return @"-";
}

- (void)setYear:(NSString *)year {
    _year = year;
    
    [self updateLabels];
}

- (void)setMake:(NSString *)make {
    _make = make;
    
    [self updateLabels];
}

- (void)setModel:(NSString *)model {
    _model = model;
    
    [self updateLabels];
}

- (IBAction)didSelectConfirmationButton:(id)sender {
    [self.delegate confirmationViewControllerDidSelectConfirm:self];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate confirmationViewController:self didSelectSelectionType:indexPath.row];
}

@end

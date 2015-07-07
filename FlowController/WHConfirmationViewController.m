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

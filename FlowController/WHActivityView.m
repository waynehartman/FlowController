//
//  WHActivityView.m
//  FlowControllerDemo
//
//  Created by Wayne Hartman on 7/6/15.
//  Copyright (c) 2015 Wayne Hartman. All rights reserved.
//

#import "WHActivityView.h"

@interface WHActivityView ()

@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation WHActivityView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    }

    return self;
}

- (UIView *)activityView {
    if (!_activityView) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicator startAnimating];

        _activityView = indicator;
        
        [self addSubview:_activityView];
    }
    
    return _activityView;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.activityView.center = CGPointMake(self.frame.size.width * 0.5f, self.frame.size.height * 0.5f);
}

@end

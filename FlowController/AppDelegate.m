//
//  AppDelegate.m
//  FlowController
//
//  Created by Wayne Hartman on 7/6/15.
//  Copyright (c) 2015 Wayne Hartman. All rights reserved.
//

#import "AppDelegate.h"
#import "WHLinearCarSelectionFlowController.h"
#import "WHSelectionViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) WHLinearCarSelectionFlowController *carSelectionFlowController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;

    self.carSelectionFlowController = [[WHLinearCarSelectionFlowController alloc] init];

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.carSelectionFlowController.initialViewController];

    self.carSelectionFlowController.navController = navController;

    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];

    return YES;
}

@end

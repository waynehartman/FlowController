//
//  WHNetworkController.h
//  FlowControllerDemo
//
//  Created by Wayne Hartman on 7/6/15.
//  Copyright (c) 2015 Wayne Hartman. All rights reserved.
//

@import Foundation;

typedef void(^WHNetworkControllerCompletionHandler)(id responseObject, NSError *error);

@interface WHNetworkController : NSObject

- (void)fetchYearsWithCompletion:(WHNetworkControllerCompletionHandler)completionHandler;
- (void)fetchMakesForYear:(NSString *)year withCompletion:(WHNetworkControllerCompletionHandler)completionHandler;
- (void)fetchModelsForYear:(NSString *)year make:(NSString *)make withCompletion:(WHNetworkControllerCompletionHandler)completionHandler;
- (void)orderVehicleWithYear:(NSString *)year make:(NSString *)make model:(NSString *)model withCompletion:(WHNetworkControllerCompletionHandler)completionHandler;

@end

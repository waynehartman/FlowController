//
//  WHNetworkController.m
//  FlowControllerDemo
//
//  Created by Wayne Hartman on 7/6/15.
//  Copyright (c) 2015 Wayne Hartman. All rights reserved.
//

#import "WHNetworkController.h"

@implementation WHNetworkController

- (NSURLSession *)session {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

    return session;
}

- (NSURL *)baseURL {
    return [NSURL URLWithString:@"http://services.waynehartman.com/cars/CarService.svc"];
}

- (void)fetchYearsWithCompletion:(WHNetworkControllerCompletionHandler)completionHandler {
    if (!completionHandler) {
        return;
    }
    
    NSURL *url = [self baseURL];
    url = [url URLByAppendingPathComponent:@"/years/"];
    
    NSURLSession *session = [self session];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                if (data) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    completionHandler(dict[@"getYearsResult"], nil);
                } else {
                    completionHandler(nil, nil);
                }
            } else {
                completionHandler(nil, error);
            }
        });
    }];

    [task resume];
}

- (void)fetchMakesForYear:(NSString *)year withCompletion:(WHNetworkControllerCompletionHandler)completionHandler {
    if (!completionHandler) {
        return;
    }
    
    NSURL *url = [self baseURL];
    url = [url URLByAppendingPathComponent:[NSString stringWithFormat:@"/makes/%@", year]];
    
    NSURLSession *session = [self session];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          if (!error) {
                                              if (data) {
                                                  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                  completionHandler(dict[@"data"], nil);
                                              } else {
                                                  completionHandler(nil, nil);
                                              }
                                          } else {
                                              completionHandler(nil, error);
                                          }
                                      });
                                  }];

    [task resume];
}

- (void)fetchModelsForYear:(NSString *)year make:(NSString *)make withCompletion:(WHNetworkControllerCompletionHandler)completionHandler {
    if (!completionHandler) {
        return;
    }
    
    NSURL *url = [self baseURL];
    url = [url URLByAppendingPathComponent:[NSString stringWithFormat:@"/models/%@/%@", year, make]];
    
    NSURLSession *session = [self session];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          if (!error) {
                                              if (data) {
                                                  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                  completionHandler(dict[@"data"], nil);
                                              } else {
                                                  completionHandler(nil, nil);
                                              }
                                          } else {
                                              completionHandler(nil, error);
                                          }
                                      });
                                  }];
    
    [task resume];
}

- (void)orderVehicleWithYear:(NSString *)year make:(NSString *)make model:(NSString *)model withCompletion:(WHNetworkControllerCompletionHandler)completionHandler {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completionHandler) {
            completionHandler(nil, nil);
        }
    });
}

@end

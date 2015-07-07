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

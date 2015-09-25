//
//  APIManager.m
//  APIDemoApp
//
//  Created by Jason Wang on 9/20/15.
//  Copyright © 2015 Jason Wang. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager

+ (void)getRequestWithURL: (NSURL *)URL completionHandler: (void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completionHandler(data, response, error);
        });
    }];
    
    [task resume];
    
}

@end

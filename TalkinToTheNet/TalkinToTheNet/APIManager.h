//
//  APIManager.h
//  APIDemoApp
//
//  Created by Jason Wang on 9/20/15.
//  Copyright © 2015 Jason Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+ (void)getRequestWithURL: (NSURL *)URL completionHandler: (void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@end

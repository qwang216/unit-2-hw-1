//
//  WeatherSearchResult.h
//  TalkinToTheNet
//
//  Created by Jason Wang on 10/2/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherSearchResult : NSObject

@property (nonatomic) NSInteger currentTemp;
@property (nonatomic) NSInteger maxTemp;
@property (nonatomic) NSInteger minTemp;
@property (nonatomic) NSString *weatherDescription;
@property (nonatomic) NSString *lngCoordinate;
@property (nonatomic) NSString *latCoordinate;


@end

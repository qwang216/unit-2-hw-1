//
//  WeatherViewController.h
//  TalkinToTheNet
//
//  Created by Jason Wang on 10/2/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FourSquareResult.h"

@interface WeatherViewController : UIViewController
@property (nonatomic) FourSquareResult *coordinates;

@end

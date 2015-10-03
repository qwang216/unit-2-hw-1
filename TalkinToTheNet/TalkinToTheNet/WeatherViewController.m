//
//  WeatherViewController.m
//  TalkinToTheNet
//
//  Created by Jason Wang on 10/2/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "WeatherViewController.h"
#import "APIManager.h"
#import "WeatherSearchResult.h"
#import "FourSquareResult.h"

@interface WeatherViewController ()

@property (nonatomic) NSMutableArray *searchResult;
@property (strong, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *maxTempLabel;
@property (strong, nonatomic) IBOutlet UILabel *minTempLabel;

@property (nonatomic) NSString *descriptionString;
@property (nonatomic) NSString *maxTempString;
@property (nonatomic) NSString *minTempString;
@property (nonatomic) NSString *currentTempString;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayTheResult];
}

-(double)converKtoF: (double)kelvin {
    double fahrenheit = ((kelvin - 273.15)* 1.80) + 32.00;
    return fahrenheit;
}

-(void)makeAPIRequestWithLng: (NSString *)lng
                      andLat: (NSString *)lat
               callBackBlock: (void (^)())block {
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@",lat, lng];
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:encodedString];
    
    [APIManager getRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.searchResult = [[NSMutableArray alloc] init];
            
            double currentTemp = [self converKtoF:[[[json objectForKey:@"main"] objectForKey:@"temp"]integerValue]];
            double maxTemp = [self converKtoF:[[[json objectForKey:@"main"] objectForKey:@"temp_max"]integerValue]];
            double minTemp = [self converKtoF:[[[json objectForKey:@"main"] objectForKey:@"temp_min"]integerValue]];
            
            self.descriptionString = [[[json objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"description"];
            self.currentTempString = [NSString stringWithFormat:@"Current Temperture: %.02f", currentTemp];
            self.maxTempString = [NSString stringWithFormat:@"Highest Temperture: %0.2f", maxTemp];
            self.minTempString = [NSString stringWithFormat:@"Lowest Temperture: %0.2f", minTemp];
            
            block();
        }
    }];
}

-(void)displayTheResult {
    NSString *resultlng = self.coordinates.lngCoordinate;
    NSString *resultlat = self.coordinates.latCoordinate;
    [self makeAPIRequestWithLng:resultlng andLat:resultlat callBackBlock:^{
        
        self.currentTempLabel.text = _currentTempString;
        self.maxTempLabel.text = _maxTempString;
        self.minTempLabel.text = _minTempString;
        self.descriptionLabel.text = _descriptionString;
    }];
    
}


@end

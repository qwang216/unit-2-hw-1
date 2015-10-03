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

-(void)makeAPIRequestWithLng: (NSString *)lng
                      andLat: (NSString *)lat
               callBackBlock: (void (^)())block {
    NSString *urlString = [NSString stringWithFormat:@"https://http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@",lat, lng];
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:encodedString];
    
    [APIManager getRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            for (NSDictionary *result in json) {
                
                WeatherSearchResult *currentResult = [[WeatherSearchResult alloc] init];
                
                
                NSString *description = [[[result objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"description"];
                currentResult.weatherDescription = description;
                self.descriptionLabel.text = self.descriptionString;
                
                NSInteger temperature = [[[result objectForKey:@"main"] objectForKey:@"temp"] integerValue];
                currentResult.currentTemp = temperature;
                
                NSInteger maxTemperature = [[[result objectForKey:@"main"] objectForKey:@"temp_max"] integerValue];
                currentResult.maxTemp = maxTemperature;
                
                NSInteger minTemperatuer = [[[result objectForKey:@"main"] objectForKey:@"temp_min"] integerValue];
                currentResult.minTemp = minTemperatuer;
                
                [self.searchResult addObject:currentResult];
            }
            block();
        }
    }];
}

-(void)displayTheResult {
    FourSquareResult *coordinates = [[FourSquareResult alloc] init];
    NSString *resultLng = coordinates.lngCoordinate;
    NSString *resultLat = coordinates.latCoordinate;
    [self makeAPIRequestWithLng:resultLng andLat:resultLat callBackBlock:^{
        WeatherSearchResult *result = [[WeatherSearchResult alloc] init];
        self.currentTempLabel.text = [NSString stringWithFormat:@"%ld", result.currentTemp];
        self.maxTempLabel.text = [NSString stringWithFormat:@"%ld", result.maxTemp];
        self.minTempLabel.text = [NSString stringWithFormat:@"%ld", result.minTemp];
        self.descriptionLabel.text = result.description;
    }];
    
}


@end

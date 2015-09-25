//
//  ViewController.m
//  TalkinToTheNet
//
//  Created by Michael Kavouras on 9/20/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "ViewController.h"
#import "APIManager.h"
#import "FourSquareResult.h"


@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate >

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *searchResult;

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTextField.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self testingAPI];

}

-(void)testingAPI{
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?query=sushi&near=ny&client_id=1WWGZGKEBJ1VLGUMAWLQEPROGSZ4U5ILXLXMFWHQRAROVUUH&client_secret=4APXHT2QAOWSGSOVUY3040XM5UBJTWJ2PNLK2AQ1L34GSXBO&v=20150925"];
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:encodedString];
    [APIManager getRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *results = json[@"response"][@"venues"];
            
            
            NSLog(@"%@",json);
        }
    }];
    
}


//-(void)makeAPIRequestWithSearchTerms: (NSString *)searchTerm callBackBlock: (void (^)())block {
//    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?query=%@&near=ny&client_id=1WWGZGKEBJ1VLGUMAWLQEPROGSZ4U5ILXLXMFWHQRAROVUUH&client_secret=4APXHT2QAOWSGSOVUY3040XM5UBJTWJ2PNLK2AQ1L34GSXBO&v=20150925", searchTerm];
//    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSURL *url = [NSURL URLWithString:encodedString];
//    
//    [APIManager getRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//       
//        if (data != nil) {
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            NSArray *results = json[@"response"][@"venues"];
//            
//        }
//    }];
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    FourSquareResult * currentResult = self.searchResult[indexPath.row];
    cell.textLabel.text = currentResult.storeName;
    
    return cell;
}

@end

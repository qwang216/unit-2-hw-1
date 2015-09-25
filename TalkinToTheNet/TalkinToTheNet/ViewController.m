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
#import "FourSquareTableViewCell.h"


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

}


-(void)makeAPIRequestWithSearchTerms: (NSString *)searchTerm callBackBlock: (void (^)())block {
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?query=%@&near=ny&client_id=1WWGZGKEBJ1VLGUMAWLQEPROGSZ4U5ILXLXMFWHQRAROVUUH&client_secret=4APXHT2QAOWSGSOVUY3040XM5UBJTWJ2PNLK2AQ1L34GSXBO&v=20150925", searchTerm];
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:encodedString];
    [APIManager getRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data != nil) {
            self.searchResult = [[NSMutableArray alloc] init];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *results = json[@"response"][@"venues"];
            
            for (NSDictionary *result in results) {
                FourSquareResult *currentResult = [[FourSquareResult alloc] init];
                
                NSString *storeName = [result objectForKey:@"name"];
                currentResult.storeName = storeName;
                
                NSString *number = [[result objectForKey:@"contact"] objectForKey:@"formattedPhone"];
                currentResult.phoneNumber = number;
                
                NSString *street = [[result objectForKey:@"location"] objectForKey:@"address"];
                NSString *city = [[result objectForKey:@"location"] objectForKey:@"city"];
                NSString *state = [[result objectForKey:@"location"] objectForKey:@"state"];
                NSString *postalCode = [[result objectForKey:@"location"] objectForKey:@"postalCode"];
                currentResult.address = [NSString stringWithFormat:@"%@ %@, %@ %@", street, city, state, postalCode];
                
                [self.searchResult addObject:currentResult];
            }
            block();
        }
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FourSquareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    FourSquareResult *result = self.searchResult[indexPath.row];
    
    cell.storeNameLabel.text = result.storeName;
    cell.phoneNumberLabel.text = result.phoneNumber;
    cell.addressLabel.text = result.address;
    return cell;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    NSString *searchTerm = self.searchTextField.text;
    
    [self makeAPIRequestWithSearchTerms:searchTerm callBackBlock:^{
        [self.tableView reloadData];
    }];
    return YES;
}




@end

//
//  FourSquareTableViewCell.h
//  TalkinToTheNet
//
//  Created by Jason Wang on 9/25/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FourSquareTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@end

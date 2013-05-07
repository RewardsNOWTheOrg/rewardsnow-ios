//
//  RNCartConfirmationViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNCartConfirmationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UILabel *pointsTotal;
@property (weak, nonatomic) IBOutlet UILabel *topPointsLabel;
- (IBAction)placeOrderTapped:(id)sender;

@end

//
//  RNCartConfirmationViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNSkinableViewController.h"

@interface RNCartConfirmationViewController : RNSkinableViewController

@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UILabel *pointsTotal;
@property (weak, nonatomic) IBOutlet UILabel *topPointsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *innerInnerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *innerViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UIView *upperOuterView;

- (IBAction)cartTapped:(id)sender;
- (IBAction)deliveryTapped:(id)sender;
- (IBAction)placeOrderTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;

@end

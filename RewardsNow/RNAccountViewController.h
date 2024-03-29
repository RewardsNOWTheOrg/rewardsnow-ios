//
//  RNAccountViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNSkinableViewController.h"

@class RNUser;

@interface RNAccountViewController : RNSkinableViewController

@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *innerViewHeight;
@property (weak, nonatomic) IBOutlet UIView *giftCardView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountNumberLabel;
@property (weak, nonatomic) IBOutlet CMLabel *pointsLabel;
@property (nonatomic, strong) RNUser *user;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftCardHeightConstraint;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *skinningButtons;
- (IBAction)logoutTapped:(id)sender;
@end

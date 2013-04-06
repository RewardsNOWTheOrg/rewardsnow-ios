//
//  RNRedeemDetailViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RNRedeemObject;

@interface RNRedeemDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *redeemBottomLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UILabel *redeemTopLabel;
@property (weak, nonatomic) IBOutlet UIImageView *redeemImage;

@property (nonatomic, strong) RNRedeemObject *info;


@end

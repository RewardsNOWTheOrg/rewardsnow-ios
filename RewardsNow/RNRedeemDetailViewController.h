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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;

@property (nonatomic, strong) RNRedeemObject *info;

- (IBAction)addToCartTapped:(id)sender;

@end

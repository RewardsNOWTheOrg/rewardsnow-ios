//
//  RNRedeemDetailViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNRedeemDetailViewController.h"
#import "RNConstants.h"
#import "RNRedeemCell.h"
#import "RNRedeemObject.h"
#import <QuartzCore/QuartzCore.h>


@interface RNRedeemDetailViewController ()

@end

@implementation RNRedeemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.descriptionView.layer.cornerRadius = 5.0;
    self.descriptionView.layer.borderColor = [[UIColor colorWithRed:C(81) green:C(130) blue:C(154) alpha:1.0] CGColor];
    self.descriptionView.layer.borderWidth = 1.0;
    
    self.redeemImage.image = self.info.image;
    self.redeemTopLabel.text = [NSString stringWithFormat:@"$%d", (NSInteger)self.info.cashValue];
    self.redeemBottomLabel.text = self.info.catagoryDescription;
    self.descriptionTextView.text = self.info.catagoryDescription;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end

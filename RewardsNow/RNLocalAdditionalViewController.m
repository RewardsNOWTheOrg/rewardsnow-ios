//
//  RNLocalAdditionalViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNLocalAdditionalViewController.h"
#import "RNLocalDeal.h"
#import "UIImageView+AFNetworking.h"
#import "RNBranding.h"
#import <QuartzCore/QuartzCore.h>

@interface RNLocalAdditionalViewController ()

@end

@implementation RNLocalAdditionalViewController

- (void)brand {
    [super brand];
    
    self.lowerView.backgroundColor = self.branding.backgroundColor;
    self.additionalInfoView.backgroundColor = self.branding.pointsColor;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.upperTopLabel.text = _deal.businessName;
    self.upperMiddleLabel.text = [NSString stringWithFormat:@"%@, %@", _deal.address, @"Philadelphia"];
    self.upperLowerLabel.text = _deal.name;
    [self.imageView setImageWithURL:_deal.imageURL];
    self.textView.text = _deal.additionalInformation;
    _additionalInfoView.layer.cornerRadius = 4.0;
    _additionalInfoView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateViewConstraints];
    [self.view layoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.textView.frame = CGRectMake(5, 62, 310, 20);
    _innerViewHeight.constant = _textView.contentSize.height + 270;
    [self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.scrollView setScrollEnabled:YES];
    CGSize size = _scrollView.contentSize;
    size.height = _innerViewHeight.constant;
    [self.scrollView setContentSize:size];
}

- (IBAction)directionsTapped:(id)sender {
    [_deal openInMaps];
}
@end

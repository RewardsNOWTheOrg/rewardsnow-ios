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
#import "RNCart.h"
#import <QuartzCore/QuartzCore.h>


@interface RNRedeemDetailViewController ()

@end

@implementation RNRedeemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.descriptionView.layer.cornerRadius = 5.0;
    
    self.redeemImage.image = self.info.image;
    self.redeemTopLabel.text = [NSString stringWithFormat:@"$%d", (NSInteger)self.info.cashValue];
    self.redeemBottomLabel.text = [NSString stringWithFormat:@"%d Points", (NSInteger)_info.priceInPoints];
    self.descriptionTextView.text = self.info.catagoryDescription;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    ///
    /// On the fly resizing of components.
    ///
    CGFloat origDiff = _descriptionView.frame.size.height - _descriptionTextView.frame.size.height;
    
    NSString *details = _info.catagoryDescription;
    CGSize size = [details sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(_descriptionTextView.frame.size.width, INFINITY) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame = _descriptionTextView.frame;
    frame.size.height = size.height + 40;
    _descriptionTextView.frame = frame;
    
    frame = _descriptionView.frame;
    frame.size.height = _descriptionTextView.frame.size.height + origDiff;
    _descriptionView.frame = frame;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:self.innerView.frame.size];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.scrollView.contentOffset = CGPointZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)addToCartTapped:(id)sender {
    [[RNCart sharedCart] addToCart:_info];
}
@end

//
//  RNAccountViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAccountViewController.h"
#import "RNCart.h"
#import "RNUser.h"
#import "RNGiftCard.h"
#import "RNConstants.h"
#import "NSString+Additions.h"
#import <QuartzCore/QuartzCore.h>
#import "RNBranding.h"

@interface RNAccountViewController ()

@property (nonatomic) CGPoint contentOffset;

@end

@implementation RNAccountViewController

- (void)brand {
    [super brand];
    
    self.nameLabel.backgroundColor = self.branding.pointsColor;
    self.nameLabel.layer.cornerRadius = 5.0;
    
    self.accountNumberLabel.backgroundColor = self.branding.pointsColor;
    self.accountNumberLabel.layer.cornerRadius = 5.0;
    
    self.giftCardView.backgroundColor = self.branding.pointsColor;
    
    for (UIButton *button in _skinningButtons) {
        button.backgroundColor = self.branding.pointsColor;
        button.layer.cornerRadius = 5.0;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentOffset = CGPointZero;
    
//    self.nameLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey-button.png"]];
//    self.accountNumberLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey-button.png"]];
    self.giftCardView.layer.cornerRadius = 5.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ( (self.branding = [RNBranding sharedBranding]) ) {
        [self brand];
    }
    
    self.user = [[RNCart sharedCart] user];
    
    if (self.user == nil) {
        UINavigationController *auth = [self.storyboard instantiateViewControllerWithIdentifier:@"RNAuthNavigationController"];
        [self presentViewController:auth animated:NO completion:nil];
    }
    
    self.topPointsLabel.text = [[RNCart sharedCart] getNamePoints];
    self.nameLabel.text = self.user.fullName;
    [self.emailLabel setTitle:self.user.email forState:UIControlStateNormal];
    
    NSString *accountNumberString = @"Account Number:";
    NSString *tipNumber = _user.tipNumber;
    NSMutableAttributedString *accountNumberText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", accountNumberString, tipNumber]];
    [accountNumberText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:17] range:NSMakeRange(0, accountNumberString.length)];
    [accountNumberText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:14] range:NSMakeRange(accountNumberString.length+1, tipNumber.length)];
    self.accountNumberLabel.attributedText = accountNumberText;

    
    for (NSInteger i = 0; i < self.user.giftCards.count; i++) {
        RNGiftCard *card = self.user.giftCards[i];
        
        UIButton *gcButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:card.cardDescription];
        [string addAttribute:NSUnderlineStyleAttributeName value:@1 range:NSMakeRange(0, string.length)];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:C(0) green:C(94) blue:C(132) alpha:1.0] range:NSMakeRange(0, string.length)];
        [gcButton setAttributedTitle:string forState:UIControlStateNormal];
        gcButton.tag = i;
        gcButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [gcButton setFrame:CGRectMake(10, 50 + (35 * i), 280, 30)];
        [gcButton addTarget:self action:@selector(giftCardTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.giftCardView addSubview:gcButton];
    }
    
    _giftCardHeightConstraint.constant = 70 + (_user.giftCards.count * 35);
    _innerViewHeight.constant = 360 + _giftCardHeightConstraint.constant;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.scrollView setScrollEnabled:YES];
    
    CGSize size = self.scrollView.contentSize;
    size.height = self.innerViewHeight.constant;
    self.scrollView.contentSize = size;
    self.scrollView.contentOffset = _contentOffset;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.scrollView.contentOffset = CGPointZero;
    self.contentOffset = self.scrollView.contentOffset;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentOffset = self.contentOffset;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)logoutTapped:(id)sender {
    
    [[RNCart sharedCart] setUser:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:BankCodeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UINavigationController *auth = [self.storyboard instantiateViewControllerWithIdentifier:@"RNAuthNavigationController"];
    [self presentViewController:auth animated:NO completion:nil];
}

- (void)giftCardTapped:(UIButton *)sender {
    [_user.giftCards[sender.tag] open];
}

@end

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

@interface RNAccountViewController ()

@property (nonatomic) CGPoint contentOffset;

@end

@implementation RNAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentOffset = CGPointZero;
    
    self.nameLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey-button.png"]];
    self.accountNumberLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey-button.png"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.user = [[RNCart sharedCart] user];
    
    if (self.user == nil) {
        UINavigationController *auth = [self.storyboard instantiateViewControllerWithIdentifier:@"RNAuthNavigationController"];
        [self presentViewController:auth animated:NO completion:nil];
    }
    
    self.topPointsLabel.text = [[RNCart sharedCart] getNamePoints];
    self.nameLabel.text = self.user.fullName;
    [self.emailLabel setTitle:self.user.email forState:UIControlStateNormal];

    
    for (NSInteger i = 0; i < self.user.giftCards.count; i++) {
        RNGiftCard *card = self.user.giftCards[i];
        
        UIButton *gcButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [gcButton setTitle:card.cardDescription forState:UIControlStateNormal];
        [gcButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        gcButton.tag = i;
        gcButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [gcButton setFrame:CGRectMake(10, 50 + (35 * i), 280, 30)];
        [gcButton addTarget:self action:@selector(giftCardTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.giftCardView addSubview:gcButton];
    }
    
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

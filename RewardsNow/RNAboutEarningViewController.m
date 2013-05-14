//
//  RNAboutEarningViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAboutEarningViewController.h"

@interface RNAboutEarningViewController ()

@property (nonatomic, copy) NSString *html;

@end

@implementation RNAboutEarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.html = @"<div /><div><div><p>There are several ways that you can earn points! Talk to an Enterprise Bank representative today to learn how you can earn points faster by requesting a Gold or Emerald level account!<\/p><table><tr><td><p /><span><b>Points Description<\/b><p /><\/span><\/td><td><p><b>Points earned with<\/b><\/p><p><b>Emerald Level Checking<\/b><\/p><\/td><td><p><b>Points earned with<\/b><\/p><p><b>Gold Level Checking<\/b><\/p><\/td><td><p><b>Points earned with<\/b><\/p><p><b>Silver Level Checking<\/b><\/p><\/td><\/tr><tr><td><p /><span>Debit Purchase when you would have signed for the purchase<p /><\/span><\/td><td><p>1 point for every $1 spent<\/p><\/td><td><p>1 point for every $2 spent<\/p><\/td><td><p>1 point for every $3 spent<\/p><\/td><\/tr><tr><td><p /><span>Debit Purchase when you enter your PIN<p /><\/span><\/td><td><p>1 point for every $4 spent<\/p><\/td><td><p>1 point for every $4 spent<\/p><\/td><td><p>1 point for every $4 spent<\/p><\/td><\/tr><tr><td><p /><span>Happy Birthday Points<p /><\/span><\/td><td><p>1000<\/p><\/td><td><p>500<\/p><\/td><td><p>250<\/p><\/td><\/tr><tr><td><p /><span>Monthly Banking eStatement Points<p /><\/span><\/td><td><p>100<\/p><\/td><td><p>100<\/p><\/td><td><p>100<\/p><\/td><\/tr><tr><td><p /><span>Use Online Bill Pay<p /><\/span><\/td><td><p>50 per use (400 max)<\/p><\/td><td><p>50 per use (300 max)<\/p><\/td><td><p>50 per use (200 max)<\/p><\/td><\/tr><tr><td><p /><span>Safe Deposit Box Rental<p /><\/span><\/td><td><p>250<\/p><\/td><td><p>250<\/p><\/td><td><p>250<\/p><\/td><\/tr><tr><td><p /><span>New Deposit Account <p /><\/span><\/td><td><p>250<\/p><\/td><td><p>250<\/p><\/td><td><p>250<\/p><\/td><\/tr><tr><td><p /><span>New Deposit Account Online<p /><\/span><\/td><td><p>additional 500<\/p><\/td><td><p>additional 500<\/p><\/td><td><p>additional 500<\/p><\/td><\/tr><tr><td><p /><span>New HELOC<p /><\/span><\/td><td><p>2,500<\/p><\/td><td><p>2,500<\/p><\/td><td><p>2,500<\/p><\/td><\/tr><tr><td><p /><span>Closed Mortgage<p /><\/span><\/td><td><p>10,000<\/p><\/td><td><p>10,000<\/p><\/td><td><p>10,000<\/p><\/td><\/tr><tr><td><p /><span>New Investment Management Relationship<p /><\/span><\/td><td><p>10,000 points for $100k-$500k<\/p><\/td><td><p>10,000 points for $100k-$500k<\/p><\/td><td><p>10,000 points for $100k-$500k<\/p><\/td><\/tr><tr><td><p /><span>First Debit Card Purchase<p /><\/span><\/td><td><p>1000<\/p><\/td><td><p>1000<\/p><\/td><td><p>1000<\/p><\/td><\/tr><tr><td><p /><span>Registering Online<p /><\/span><\/td><td><p>500<\/p><\/td><td><p>500<\/p><\/td><td><p>500<\/p><\/td><\/tr><\/table><p><b>Earn bonus points<\/b><b> with ShoppingFLING<\/b><\/p><p>Earn bonus points on your rewards program when you use the ShoppingFLING feature. This terrific program is an added benefit and a convenient way to shop, while earning more points. But, even better, you earn these extra bonus points no matter how you shop – online, at a retail location, or by phone at any of participating merchants found on the ShoppingFLING website.<\/p><p>Also, be on the lookout for monthly deals and discounts through email. How do you take advantage of this super-rewarding program feature? Simply click on the ShoppingFLING tab above, and you’re on your way to building points while you shop! What’s not to love?<\/p><p><b>When you’re ready, you can do all of your redemptions online<\/b><\/p><p>Select from the hundreds of items available in the <a>online catalog<\/a> and compare your <a>available points<\/a> with the number needed for the item you want. Downloadable rewards can be received instantly. If you have any questions, you can call the Rewards Service Center at 1-855-888-9838, 24 hours a day, 7 days a week. A Redemption Specialist will be happy to assist you.<\/p><p><a>Click here to redeem your points!<\/a><\/p><\/div><div><p>*With an enrolled card, points are not earned on the following: tax payments, any unauthorized charges or transactions, ATM withdrawals, or any fees including ATM fees and card-related charges posted to an enrolled card account as outlined in the applicable Cardholder Agreement, except as otherwise permitted in special promotional offers.<\/p><p>You will earn negative points if returns or credits exceed purchases. Points may not be purchased.<\/p><p>Net purchases are defined as the dollar value of goods and services purchased with a Card beginning with the first day of the billing cycle that includes Cardholder&amp;#39;s Enrollment Date, minus any credits, returns, or other adjustments as reflected on monthly billing statements.<\/p><\/div><\/div>";
    
    [self.webView loadHTMLString:_html baseURL:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _webView.scrollView.scrollEnabled = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    CGFloat topDiff = _webView.frame.origin.y;
    _webViewHeight.constant = _webView.scrollView.contentSize.height;
    self.scrollView.contentSize = CGSizeMake(320, _webViewHeight.constant + topDiff);
    DLog(@"Size: %@", NSStringFromCGSize(self.scrollView.contentSize));
    [self.view layoutIfNeeded];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end

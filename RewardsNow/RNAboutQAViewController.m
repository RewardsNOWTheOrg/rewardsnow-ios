//
//  RNAboutQAViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAboutQAViewController.h"

@interface RNAboutQAViewController ()

@property (nonatomic, copy) NSString *html;

@end

@implementation RNAboutQAViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    /// API call
    self.html = @"<p><b>What is My Enterprise Rewards?<\/b><\/p><p>It’s a unique program that rewards you for using your Enterprise Bank Debit Card.<\/p><p /><p><b>What makes My Enterprise Rewards different from &amp;quot;frequent flier&amp;quot; programs?<\/b><\/p><p>Unlike typical frequent flier programs, your points are good for absolutely anything.You can book either through your preferred travel agency, direct with travel providers,or on the internet. Any airline… Any hotel or resort… Any train trip… Any cruiseline… Any rental car… YOU NAME IT! <\/p><p /><p><b>What if I don’t want to travel?<\/b> <\/p><p>You can redeem your points for <a>gifts<\/a> and<a>gift cards<\/a> by visiting our online rewards catalog.<\/p><p /><p><b>How do I earn points? <\/b><\/p><p>You earn <b>one point<\/b> for every <b>one dollar<\/b> ($1) you spend on eligibleMy Enterprise Rewards Emerald Debit Card purchases when you sign for the purchase.If you choose to enter your PIN for the purchase, you will only earn <b>one point<\/b><b>four dollars<\/b> ($4) you spend.<\/p><p /><p>You earn <b>one<\/b> <b>point<\/b> for every <b>two dollars<\/b> ($2) spent on eligibleMy Enterprise Rewards Gold Debit Card purchases. If you choose to enter your PINfor the purchase, you will only earn <b>one point<\/b> for every <b>four dollars<\/b><\/p><p /><p>You earn <b>one point<\/b> for every <b>three dollars<\/b> ($3) spent on eligibleMy Enterprise Rewards Silver Debit Card purchases. If you choose to enter your PINfor the purchase, you will only earn <b>one point<\/b> for every <b>four dollars<\/b><\/p><p /><p>Additional point earning opportunities can be found on the<a>Earning Points<\/a> page. We keep track of all the points you’veearned and provide you with a monthly <a>My Enterprise Rewardse-statement<\/a>.<\/p><p /><p><b>How do I earn bonus points?<\/b><\/p><p>Earn bonus points on your rewards program when you use the<a>ShoppingFLING<\/a> feature. This terrific program is an addedbenefit and a convenient way to shop, while earning more points. But, even better,you earn these extra bonus points no matter how you shop – online, at a retail locationor by phone at any of participating merchants found on the ShoppingFLING website.Also, be on the lookout for monthly deals and discounts through email. Simply clickthe &amp;quot;Shopping&amp;quot; tab above, click on the ShoppingFLING bag, and you’re on your wayto building points while you shop!<\/p><p /><p><b>When can I redeem points? <\/b><\/p><p>You can redeem points any time and can redeem as few as 750 points.<\/p><p /><p><b>How do I redeem for travel? <\/b><\/p><p>We offer 3 easy ways to redeem your points for travel. Simply use our<a>Travel Resource Center<\/a> to book online, redeem for a travelrebate certificate, or speak with our travel agency. If you need assistance, callour Service Center toll-free at 855-888-9838 24 hours a day, 7 days a week.<\/p><p /><p><b>What if I already took a trip? Can I still get value from my points? <\/b><\/p><p>Yes, as long as the date of travel occurred after the My Enterprise Rewards pointswere accumulated. Just send us a <a>Travel Rebate Certificate<\/a><\/p><p /><p><b>How do I redeem for gifts? <\/b><\/p><p>Redeeming My Enterprise Rewards points for <a>gifts<\/a><a>gift cards<\/a> is just as easy. Simply compare the totalpoints you’ve accumulated with the number needed for the items you want. If youhave enough points, go ahead and redeem. If you need assistance, call our live MyEnterprise Rewards Service Center toll free at 855-888-9838. Our reward specialistwill take your order and you will receive your items within 2-4 weeks.<\/p><p /><p><b>Can My Enterprise Rewards points be combined with points earned on other programs?<\/b><\/p><p>Points may not be combined with, or transferred to, other rewards programs, butfamily members, if cardholders of Enterprise Bank, may combine rewards accounts.Contact an Enterprise Bank representative for details.<\/p><p /><p><b>Do My Enterprise Rewards points expire? <\/b><\/p><p>They’re good for three (3) years from the month they’re earned. So there’s plentyof time (and ways) to use your points.<\/p><p /><p><b>Are My Enterprise Rewards points transferable? <\/b><\/p><p>Points are not transferable.<\/p>";
    
    [self.webView loadHTMLString:_html baseURL:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _webView.scrollView.scrollEnabled = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat topDiff = _webView.frame.origin.y;
    _webViewHeight.constant = _webView.scrollView.contentSize.height;
    self.scrollView.contentSize = CGSizeMake(320, _webViewHeight.constant + topDiff);
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end

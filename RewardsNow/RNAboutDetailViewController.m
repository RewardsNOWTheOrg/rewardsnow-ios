//
//  RNAboutEarningViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAboutDetailViewController.h"
#import "RNBranding.h"

@interface RNAboutDetailViewController ()

@end

@implementation RNAboutDetailViewController

- (void)brand {
    [super brand];
    [self.webView setOpaque:NO];
    [self.webView setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerImageView.image = self.branding.headerImage;
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}

@end

//
//  RNAboutQAViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNAboutQAViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *innerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

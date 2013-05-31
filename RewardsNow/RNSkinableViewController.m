//
//  RNSkinableViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 5/31/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNSkinableViewController.h"
#import "RNBranding.h"

@interface RNSkinableViewController ()

@end

@implementation RNSkinableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ( (self.branding = [RNBranding sharedBranding]) ) {
        [self brand];
    }
}

- (void)brand {
    
    self.view.backgroundColor = _branding.backgroundColor;
    self.navigationController.navigationBar.tintColor = _branding.menuBackgroundColor;
    [self.tabBarController.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor: _branding.tabBarTextColor} forState:UIControlStateNormal];
    [self.tabBarController.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor: _branding.tabBarTextColor} forState:UIControlStateNormal];
}

@end

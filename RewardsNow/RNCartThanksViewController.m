//
//  RNCartThanksViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNCartThanksViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RNCart.h"

@interface RNCartThanksViewController ()

@end

@implementation RNCartThanksViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.topPointsLabel.text = [[RNCart sharedCart] getNamePoints];
    
    //
    // On this screen showing, change the underlaying tab to the Account screen
    //
    UITabBarController *tabBar = (UITabBarController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    if ([tabBar isKindOfClass:[UITabBarController class]]) {
        [tabBar setSelectedIndex:3];
        UINavigationController *third = tabBar.viewControllers[3];
        if ([third isKindOfClass:[UINavigationController class]]) {
            [third popToRootViewControllerAnimated:NO];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.upperView.layer.masksToBounds = NO;
    self.upperView.layer.shadowOffset = CGSizeMake(0, 5);
    self.upperView.layer.shadowOpacity = 0.5;
    
    [self.thankYouButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.navigationItem setHidesBackButton:YES];
}

- (IBAction)thankYouTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

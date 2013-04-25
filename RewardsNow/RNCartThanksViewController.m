//
//  RNCartThanksViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNCartThanksViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RNCartThanksViewController ()

@end

@implementation RNCartThanksViewController


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.upperView.layer.masksToBounds = NO;
    self.upperView.layer.shadowOffset = CGSizeMake(0, 5);
    self.upperView.layer.shadowOpacity = 0.5;
    
    [self.thankYouButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)thankYouTapped:(id)sender {
    DLog(@"Button: %@", NSStringFromCGRect([sender frame]));
    DLog(@"1: %d", [sender contentMode]);
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

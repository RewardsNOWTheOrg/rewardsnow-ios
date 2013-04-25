//
//  RNLocalMapViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNLocalMapViewController.h"

@interface RNLocalMapViewController ()

@end

@implementation RNLocalMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    DLog(@"Frame: %@", NSStringFromCGRect(self.searchDisplayController.searchBar.frame));
}

@end

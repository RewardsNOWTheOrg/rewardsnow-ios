//
//  RNAuthViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/18/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAuthViewController.h"

@interface RNAuthViewController ()

@end

static NSArray *fields = nil;

@implementation RNAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    fields = @[self.usernameTextField, self.passwordTextField, self.codeTextField, self.signInButton, self.forgotPasswordButton];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    for (NSInteger i = 0; i < fields.count; i++) {
        UIView *view = fields[i];
        
        [UIView animateWithDuration:0.5 delay:(i * 0.15) options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.alpha = 1.0;
        } completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

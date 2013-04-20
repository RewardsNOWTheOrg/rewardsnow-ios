//
//  RNAuthViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/18/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAuthViewController.h"
#import "RNConstants.h"
#import "MBProgressHUD.h"
#import "RNWebService.h"
#import "RNUser.h"
#import "RNCart.h"
#import "RNConstants.h"

#define kUsernameTextFieldTag 1
#define kPasswordTextFieldTag 2
#define kCodeTextFieldTag 3
#define kStatusBarHeight 20


@interface RNAuthViewController ()

@property (nonatomic, copy) NSArray *fields;

@end



@implementation RNAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fields = @[self.usernameTextField, self.passwordTextField, self.signInButton, self.forgotPasswordButton];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (!IS_WIDESCREEN) {
        self.logoTopConstraint.constant = 35;
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    for (NSInteger i = 0; i < _fields.count; i++) {
        UIView *view = _fields[i];
        
        [UIView animateWithDuration:0.5 delay:(i * 0.15) options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.alpha = 1.0;
        } completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = self.view.frame;
    frame.origin.y = IS_WIDESCREEN ? -(135 + kStatusBarHeight) : -(110 + kStatusBarHeight);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = frame;
    }];
}


- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (IBAction)signInTapped:(id)sender {
    [self backgroundTapped:nil];
    ///
    /// Perform authentication...
    ///
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RNWebService sharedClient] getAccountInfoWithTip:[NSNumber numberWithLongLong:969999999999999] callback:^(RNUser *result) {
        
        [[RNCart sharedCart] setUser:result];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
}

- (IBAction)forgotPasswordTapped:(id)sender {
    
}
@end

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
#import "RNBranding.h"
#import <QuartzCore/QuartzCore.h>

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
    
    self.logoImageView.image = self.branding.headerImage;
    self.signInButton.backgroundColor = self.branding.submitButtonColor;
    self.signInButton.layer.cornerRadius = 2.0;
    
    _fields = @[self.usernameTextField, self.passwordTextField, self.signInButton, self.forgotPasswordButton];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (!IS_WIDESCREEN) {
        self.logoTopConstraint.constant = 35;
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

//remove
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    self.usernameTextField.text = @"969test";
//    self.passwordTextField.text = @"sample";
//    [self signInTapped:nil];
//}


- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (IBAction)signInTapped:(id)sender {
    [self backgroundTapped:nil];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"signing in...";
    
    [[RNWebService sharedClient] loginWithUsername:_usernameTextField.text password:_passwordTextField.text callback:^(id result) {
        
        if ([result boolValue]) {
            
            [[RNWebService sharedClient] getAccountInfoWithTipWithCallback:^(id result) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (result != nil) {
                    [[RNCart sharedCart] setUser:result];
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [self presentError:@"There was an error getting your user profile, please try again."];
                }
            }];
            
        } else { //FAILED
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self presentError:@"Username or password was incorrect."];
        }
    }];
}

- (void)presentError:(NSString *)error {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
}

- (IBAction)forgotPasswordTapped:(id)sender {
    
}
@end

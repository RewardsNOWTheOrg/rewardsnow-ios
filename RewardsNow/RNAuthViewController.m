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
#import "RNResponse.h"
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
    
    self.logoImageView.layer.borderWidth = 1.0;
    self.logoImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.fields = @[self.usernameTextField, self.passwordTextField, self.signInButton, self.forgotPasswordButton];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (!IS_WIDESCREEN) {
        self.logoTopConstraint.constant = 35;
    }
    
    if (_isFor401Response) {
        self.loginTextLabel.text = @"You have been logged out due to inactivity. Please login to continue.";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.signInButton.enabled = [self canSignIn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = self.view.frame;
    frame.origin.y = IS_WIDESCREEN ? -(135 + kStatusBarHeight) : -(120 + kStatusBarHeight);
    
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"signing in...";
    
    [[RNWebService sharedClient] loginWithUsername:_usernameTextField.text password:_passwordTextField.text callback:^(RNResponse *response) {
        
        if ([response.result boolValue]) {
            
            [[RNWebService sharedClient] getAccountInfoWithTipWithCallback:^(RNResponse *accountInfoResponse) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([accountInfoResponse wasSuccessful]) {
                    [[RNCart sharedCart] setUser:accountInfoResponse.result];
                    [[[RNCart sharedCart] user] setUsername:_usernameTextField.text];
                    [[RNCart sharedCart] updateCartFromWeb];
                    
                    if ([self.delegate respondsToSelector:@selector(authViewController:didFinish:)]) {
                        [self.delegate authViewController:self didFinish:YES];
                    }
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        if ([self.delegate respondsToSelector:@selector(authViewControllerDidDismiss:)]) {
                            [self.delegate authViewControllerDidDismiss:self];
                        }
                    }];
                } else {
                    [self presentError:response.errorString];
                }
            }];
        } else { //FAILED
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self presentError:response.errorString];
        }
    }];
}

- (void)presentError:(NSString *)error {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (IBAction)forgotPasswordTapped:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Forgot Password?" message:@"Please visit your rewards program website or your financial institution's website to reset your password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (IBAction)textFieldChanged:(UITextField *)sender {
    self.signInButton.enabled = [self canSignIn];
}

- (BOOL)canSignIn {
    return [self.usernameTextField.text isNotEmpty] && [self.passwordTextField.text isNotEmpty];
}

@end

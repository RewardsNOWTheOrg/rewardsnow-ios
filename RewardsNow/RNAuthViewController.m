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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"signing in...";
    [[RNWebService sharedClient] getAccountInfoWithTip:@[@969999999999999, @969999999999998, @969999999999997, @969999999999996][arc4random_uniform(3)] callback:^(RNUser *result) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (result != nil) {
            [[RNCart sharedCart] setUser:result];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error authenticating, please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        }
    }];
}

- (IBAction)forgotPasswordTapped:(id)sender {
    
}
@end

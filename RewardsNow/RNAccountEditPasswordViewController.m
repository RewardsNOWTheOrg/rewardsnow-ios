//
//  RNAccountEditPasswordViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAccountEditPasswordViewController.h"
#import "RNWebService.h"
#import "MBProgressHUD.h"
#import "RNUser.h"
#import "RNCart.h"
#import "RNResponse.h"

@interface RNAccountEditPasswordViewController ()

@end

@implementation RNAccountEditPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.passwordOldTextField becomeFirstResponder];
    self.saveButton.enabled = NO;
}

- (IBAction)saveTapped:(id)sender {
    [self.view endEditing:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.detailsLabelText = @"Changing...";
    
    RNUser *user = [[RNCart sharedCart] user];
    
    [[RNWebService sharedClient] postChangePasswordWithUsername:user.username
                                                    oldPassword:_passwordOldTextField.text
                                                    newPassword:_passwordNewTextField.text
                                                confirmPassword:_passwordNewRetypeTextField.text
                                                       callback:^(RNResponse *response) {
                                                           hud.mode = MBProgressHUDModeCustomView;
                                                           
                                                           if ([response wasSuccessful]) {
                                                               hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                                                               hud.detailsLabelText = @"Completed";
                                                               [hud hide:YES afterDelay:1.5];
                                                               [self.navigationController popViewControllerAnimated:YES];
                                                           } else {
                                                               [[[UIAlertView alloc] initWithTitle:@"Error" message:response.errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                               [hud hide:YES];
                                                           }
                                                       }];
}

- (IBAction)textFieldChanged:(UITextField *)sender {
    self.saveButton.enabled = [self isRequiredInfoEntered];
}

- (BOOL)isRequiredInfoEntered {
    return _passwordOldTextField.text.length > 0 &&
        _passwordNewTextField.text.length > 0 &&
        _passwordNewRetypeTextField.text.length > 0 &&
        [_passwordNewTextField.text isEqualToString:_passwordNewRetypeTextField.text];
}


@end

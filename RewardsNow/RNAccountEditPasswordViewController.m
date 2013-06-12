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

@interface RNAccountEditPasswordViewController ()

@end

@implementation RNAccountEditPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.passwordOldTextField becomeFirstResponder];
    self.saveButton.enabled = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
                                                       callback:^(id result) {
                                                           hud.mode = MBProgressHUDModeCustomView;
                                                           
                                                           if ([result boolValue]) {
                                                               hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                                                               hud.detailsLabelText = @"Completed";
                                                           } else {
                                                               hud.detailsLabelText = @"Error";
                                                           }
                                                           [hud hide:YES afterDelay:1.5];
                                                           [self.navigationController popViewControllerAnimated:YES];
                                                       }];
}

- (BOOL)isRequiredInfoEntered {
    return ![self isEmpty:self.passwordOldTextField.text] && ![self isEmpty:self.passwordNewTextField.text] && ![self isEmpty:self.passwordNewRetypeTextField.text];
}

- (BOOL)isEmpty:(NSString *)string {
    
    if([string length] == 0) {
        return YES;
    }
    
    if(![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self isRequiredInfoEntered]) {
        self.saveButton.enabled = YES;
    }
    return YES;
}


@end

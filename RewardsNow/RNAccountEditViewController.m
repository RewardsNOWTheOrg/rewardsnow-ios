//
//  RNAccountEditViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAccountEditViewController.h"
#import "MBProgressHUD.h"
#import "RNCart.h"
#import "RNUser.h"
#import "RNWebService.h"
#import "RNResponse.h"

@interface RNAccountEditViewController ()

@end

@implementation RNAccountEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.saveButton.enabled = NO;
}

- (IBAction)saveTapped:(id)sender {
    
    [self.view endEditing:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.detailsLabelText = @"Changing...";
    
    [[RNWebService sharedClient] putEmail:self.emailTextField.text callback:^(RNResponse *response) {
        
        hud.mode = MBProgressHUDModeCustomView;
        
        if ([response wasSuccessful]) {
            NSString *email = response.result;
            
            RNUser *user = [[RNCart sharedCart] user];
            user.email = email;
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

- (IBAction)textFieldChanged:(id)sender {
    self.saveButton.enabled = [self shouldEnableSaveButton];
}

- (BOOL)shouldEnableSaveButton {
    return self.emailTextField.text.length > 0 &&
        self.emailAgainTextField.text.length > 0 &&
        [self.emailTextField.text isEqualToString:self.emailAgainTextField.text];
}

@end

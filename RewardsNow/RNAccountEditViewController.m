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
    
    RNUser *user = [[RNCart sharedCart] user];
    self.nameLabel.text = user.fullName;
    self.emailTextField.text = user.email;
    self.saveButton.enabled = NO;


}

- (IBAction)saveTapped:(id)sender {
    
    [self.view endEditing:YES];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"Changing...";
    
    [[RNWebService sharedClient] putEmail:self.emailTextField.text callback:^(id result) {
        
        hud.mode = MBProgressHUDModeCustomView;
        
        [hud hide:YES afterDelay:1.5];
        
        if (result != nil) {
            RNUser *user = [[RNCart sharedCart] user];
            user.email = self.emailTextField.text;
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.detailsLabelText = @"Completed";
        } else {
            hud.detailsLabelText = @"Error";
        }
    }];
    
}

#pragma mark UITextFild Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.saveButton.enabled = YES;
    return YES;
}

@end

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

@interface RNAccountEditPasswordViewController ()

@end

@implementation RNAccountEditPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.passwordOldTextField becomeFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)saveTapped:(id)sender {
    [self.view endEditing:YES];
    
    if ([self isRequiredInfoEntered]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.detailsLabelText = @"Changing...";
        
        [[RNWebService sharedClient] putPasswordFrom:self.passwordOldTextField.text
                                         oldPassword:self.passwordNewTextField.text
                                             retyped:self.passwordNewRetypeTextField.text
                                            callback:^(id result) {
                                                
                                                hud.mode = MBProgressHUDModeCustomView;
                                                
                                                if (result != nil) {
                                                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                                                    hud.detailsLabelText = @"Completed";
                                                } else {
                                                    hud.detailsLabelText = @"Error";
                                                }
                                                [hud hide:YES afterDelay:1.5];
                                            }];

    }
    
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


@end

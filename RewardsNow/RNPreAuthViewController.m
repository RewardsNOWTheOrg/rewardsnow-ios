//
//  RNPreAuthViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/20/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNPreAuthViewController.h"
#import "RNConstants.h"
#import "MBProgressHUD.h"
#import "RNAuthViewController.h"

@interface RNPreAuthViewController ()

@property (nonatomic, copy) NSArray *fields;

@end

@implementation RNPreAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fields = @[self.codeTextField, self.continueButton];
    [self.navigationController setNavigationBarHidden:YES];
    
    if (!IS_WIDESCREEN) {
        self.logoTopConstraint.constant = 42;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGRect frame = self.view.frame;
    frame.origin.y = -30;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = frame;
    }];
}

- (IBAction)continueTapped:(id)sender {
    ///
    /// Get bank information and then skin
    ///
    [self backgroundTapped:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"loading...";
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        ///
        /// Skin the application
        ///
        
        hud.detailsLabelText = @"skinning...";
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            RNAuthViewController *auth = [self.storyboard instantiateViewControllerWithIdentifier:@"RNAuthViewController"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController pushViewController:auth animated:YES];
            
        });
    });
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}
@end

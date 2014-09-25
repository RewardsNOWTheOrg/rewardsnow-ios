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
#import "RNWebService.h"
#import "RNBranding.h"
#import "RNResponse.h"
#import <QuartzCore/QuartzCore.h>

@interface RNPreAuthViewController ()

@property (nonatomic, copy) NSArray *fields;
@property (atomic) BOOL hasFinishedDownloadingImage;
@property (atomic) BOOL hasFinishedDownloadingBranding;
@property (nonatomic, strong) RNBranding *branding;

@end

@implementation RNPreAuthViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    self.hasFinishedDownloadingImage = NO;
    self.hasFinishedDownloadingBranding = NO;
    self.fields = @[self.headerImageView, self.helperLabel, self.codeTextField, self.continueButton];
    [self.navigationController setNavigationBarHidden:YES];
    self.codeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"3 character program ID"
                                                                               attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    if (!IS_WIDESCREEN) {
        self.logoTopConstraint.constant = 42;
    }
    
    self.codeTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:BankCodeKey];
    self.continueButton.enabled = [self canContinue];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationPosted:) name:kImageDidFinishDownloadingNotification object:nil];
    
    for (NSInteger i = 0; i < _fields.count; i++) {
        UIView *view = _fields[i];
        
        [UIView animateWithDuration:0.5 delay:(i * 0.15) options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.alpha = 1.0;
        } completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    
    CGRect frame = self.view.frame;
    frame.origin.y = IS_WIDESCREEN ? -60 : -100;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = frame;
    }];

}

- (IBAction)continueTapped:(id)sender;
{
    
    [[NSUserDefaults standardUserDefaults] setObject:self.codeTextField.text forKey:BankCodeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ///
    /// Get bank information and then skin
    ///
    [self backgroundTapped:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"loading...";
    
    [[RNWebService sharedClient] getBranding:self.codeTextField.text callback:^(RNResponse *response) {
        
        if ([response wasSuccessful]) {
            self.branding = response.result;
            self.hasFinishedDownloadingBranding = YES;
            [[RNWebService sharedClient] setTipNumber:_codeTextField.text];
            if (self.hasFinishedDownloadingImage) {
                [self skin];
            }
            
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:response.errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [hud hide:YES];
        }
    }];
}

- (void)notificationPosted:(NSNotification *)note;
{
    self.hasFinishedDownloadingImage = YES;
    if (self.hasFinishedDownloadingBranding) {
        [self skin];
    }
}

- (void)skin;
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    hud.detailsLabelText = @"skinning...";
    
    UIImageView *newHeader = [[UIImageView alloc] initWithFrame:_headerImageView.frame];
    newHeader.image = _branding.headerImage;
    newHeader.alpha = 0.0;
    [self.view addSubview:newHeader];
    
    [UIView animateWithDuration:2.0 animations:^{

        self.headerImageView.alpha = 0.0;
        newHeader.alpha = 1.0;
        self.view.backgroundColor = [UIColor whiteColor];
        
        [self.branding globalBranding];
    } completion:^(BOOL finished) {
        [self continueAfterProcessing];
    }];

}

- (void)continueAfterProcessing;
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    RNAuthViewController *auth = [self.storyboard instantiateViewControllerWithIdentifier:@"RNAuthViewController"];
    [self.navigationController pushViewController:auth animated:YES];
}

- (IBAction)backgroundTapped:(id)sender;
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (IBAction)textFieldChanged:(UITextField *)sender;
{
    self.continueButton.enabled = [self canContinue];
}

- (BOOL)canContinue;
{
    return self.codeTextField.text.length > 0;
}

@end

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

@interface RNPreAuthViewController ()

@property (nonatomic, copy) NSArray *fields;
@property (atomic) BOOL hasFinishedDownloadingImage;
@property (atomic) BOOL hasFinishedDownloadingBranding;
@property (nonatomic, strong) RNBranding *branding;

@end

@implementation RNPreAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasFinishedDownloadingImage = NO;
    self.hasFinishedDownloadingBranding = NO;
    self.fields = @[self.helperLabel, self.codeTextField, self.continueButton];
    [self.navigationController setNavigationBarHidden:YES];
    
    if (!IS_WIDESCREEN) {
        self.logoTopConstraint.constant = 42;
    }
    
    self.codeTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:BankCodeKey];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationPosted:) name:kImageDidFinishDownloadingNotification object:nil];
    
    for (NSInteger i = 0; i < _fields.count; i++) {
        UIView *view = _fields[i];
        
        [UIView animateWithDuration:0.5 delay:(i * 0.15) options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.alpha = 1.0;
        } completion:nil];
    }
    
//    //testing
    double delayInSeconds = .5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self continueTapped:nil];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGRect frame = self.view.frame;
    frame.origin.y = IS_WIDESCREEN ? -60 : -100;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = frame;
    }];

}

- (IBAction)continueTapped:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:self.codeTextField.text forKey:BankCodeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ///
    /// Get bank information and then skin
    ///
    [self backgroundTapped:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"loading...";
    
    [[RNWebService sharedClient] getBranding:self.codeTextField.text callback:^(id result) {
        
        if (result != nil) {
            self.branding = result;
            self.hasFinishedDownloadingBranding = YES;
            [[RNWebService sharedClient] setTipNumber:_codeTextField.text]; //SET FOREVER.
            if (self.hasFinishedDownloadingImage) {
                [self skin];
            }
            
        } else {
            hud.detailsLabelText = @"Error!";
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-XMark.png"]];
            [hud hide:YES afterDelay:1.5];
        }
    }];
}

- (void)notificationPosted:(NSNotification *)note {
    self.hasFinishedDownloadingImage = YES;
    if (self.hasFinishedDownloadingBranding) {
        [self skin];
    }
}

- (void)skin {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    hud.detailsLabelText = @"skinning...";
    
    UIImageView *newHeader = [[UIImageView alloc] initWithFrame:_headerImageView.frame];
    newHeader.image = _branding.headerImage;
    newHeader.alpha = 0.0;
    [self.view addSubview:newHeader];
    
    [UIView animateWithDuration:2.0 animations:^{

        self.headerImageView.alpha = 0.0;
        newHeader.alpha = 1.0;
        
        [self.branding globalBranding];
    } completion:^(BOOL finished) {
        [self continueAfterProcessing];
    }];

}

- (void)continueAfterProcessing {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    RNAuthViewController *auth = [self.storyboard instantiateViewControllerWithIdentifier:@"RNAuthViewController"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.navigationController pushViewController:auth animated:YES];
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}
@end

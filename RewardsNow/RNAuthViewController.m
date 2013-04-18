//
//  RNAuthViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/18/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAuthViewController.h"

#define kUsernameTextFieldTag 1
#define kPasswordTextFieldTag 2
#define kCodeTextFieldTag 3
#define kStatusBarHeight 20

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface RNAuthViewController ()

@property (nonatomic, copy) NSArray *fields;

@end



@implementation RNAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fields = @[self.usernameTextField, self.passwordTextField, self.codeTextField, self.signInButton, self.forgotPasswordButton];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = self.view.frame;
    
    switch (textField.tag) {
        case kUsernameTextFieldTag:
        {
            frame.origin.y = IS_WIDESCREEN ? -(135 + kStatusBarHeight) : 0;
            break;
        }
        case kPasswordTextFieldTag:
        {
            frame.origin.y = IS_WIDESCREEN ? -(135 + kStatusBarHeight) : 0;
            break;
        }
        case kCodeTextFieldTag:
        {
            frame.origin.y = IS_WIDESCREEN ? -(135 + kStatusBarHeight) : 0;
            break;
        }
        default:
            break;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}


- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, kStatusBarHeight, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (IBAction)signInTapped:(id)sender {
    ///
    /// Perform authentication...
    ///
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)forgotPasswordTapped:(id)sender {
    
}
@end

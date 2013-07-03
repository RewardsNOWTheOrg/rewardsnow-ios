//
//  RNCartAccountViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNCart.h"
#import "RNCartAccountViewController.h"
#import "RNUser.h"
#import "RNBranding.h"

#define kKeyboardHeight 216
#define kStatusBarHeight 20
#define kViewChangeForKeyboard 120
#define kScrollToNearBottom 105

@interface RNCartAccountViewController ()

@property (nonatomic) CGRect scrollViewFrame;

@end

@implementation RNCartAccountViewController

- (void)brand {
    [super brand];
    
    self.upperOuterView.backgroundColor = self.branding.backgroundColor;
    self.upperInnerView.backgroundColor = self.branding.pointsColor;
    
    self.lowerOuterView.backgroundColor = self.branding.backgroundColor;
    self.lowerInnerView.backgroundColor = self.branding.pointsColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollViewFrame = CGRectNull;
    
    RNUser *user = [[RNCart sharedCart] user];
    self.topPointsLabel.text = [[RNCart sharedCart] getNamePoints];
    self.emailTextField.text = user.email;
    
    _addressNameTextField.text = user.fullName;
    _addressStreetTextField.text = user.address;
    _addressUnitTextField.text = user.apt;
    NSString *cityState = [[user.city stringByAppendingFormat:@" %@", user.state] stringByAppendingFormat:@" %@", user.zipCode];
    cityState = [cityState stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _addressCityStateTextField.text = cityState;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:self.innerView.frame.size];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.scrollView.contentOffset = CGPointZero;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

    if (textField.tag > 1) {
        if (CGRectEqualToRect(_scrollViewFrame, CGRectNull)) {
            self.scrollViewFrame = self.scrollView.frame;
        }
        CGRect frame = self.view.frame;
        frame.origin.y = -kViewChangeForKeyboard;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = frame;
            self.scrollView.frame = CGRectMake(0, kViewChangeForKeyboard, [[UIScreen mainScreen] bounds].size.width,
                                               [[UIScreen mainScreen] bounds].size.height - (self.navigationController.navigationBar.frame.size.height + kKeyboardHeight + kStatusBarHeight));
            CGPoint bottomOffset = CGPointMake(0, kScrollToNearBottom);
            [self.scrollView setContentOffset:bottomOffset animated:YES];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self endEditing];
    return YES;
}

- (void)endEditing {
    [self.view endEditing:YES];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = frame;
        if (!CGRectEqualToRect(_scrollViewFrame, CGRectNull)) {
            self.scrollView.frame = _scrollViewFrame;
        }
        
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"pushRNCartConfirmationViewController"] || [[segue identifier] isEqualToString:@"pushRNCartConfirmationViewControllerFromConfirm"]) {
        //
        // save info
        //
        
        RNUser *user = [[RNCart sharedCart] user];

        user.shouldSetCurrenetEmailToDefault = _defaultEmailSwitch.on;
        user.email = _emailTextField.text;
        user.fullName = _addressNameTextField.text;
        user.address = _addressStreetTextField.text;
        user.apt = _addressUnitTextField.text;
#warning Need to see how to store city/state/etc
    }
}


- (IBAction)cartButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

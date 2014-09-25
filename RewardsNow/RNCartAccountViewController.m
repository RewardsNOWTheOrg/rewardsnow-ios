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
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>

#define kKeyboardHeight 216
#define kStatusBarHeight 20
#define kViewChangeForKeyboard 120
#define kScrollToNearBottom 125
#define kTopBarHeight 70
#define kTextFieldMoveDistance 35

@interface RNCartAccountViewController ()

@property (nonatomic) CGRect scrollViewFrame;
@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, assign) NSInteger editingTag;

@end

@implementation RNCartAccountViewController

- (void)brand {
    [super brand];
    
    self.upperOuterView.backgroundColor = self.branding.backgroundColor;
    self.upperInnerView.backgroundColor = self.branding.pointsColor;
    
    self.lowerOuterView.backgroundColor = self.branding.backgroundColor;
    self.lowerInnerView.backgroundColor = self.branding.pointsColor;
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
    self.scrollViewFrame = CGRectNull;
    
    RNUser *user = [[RNCart sharedCart] user];
    self.topPointsLabel.text = [[RNCart sharedCart] getNamePoints];
    self.emailTextField.text = user.email;
    
    _addressNameTextField.text = user.fullName;
    _addressStreetTextField.text = user.address;
    _addressUnitTextField.text = user.apt;
    _addressCityTextField.text = user.city;
    _addressStateTextField.text = user.state;
    _addressZipTextField.text = user.zipCode;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:self.innerView.frame.size];
    self.originalFrame = self.view.frame;
}

- (void)viewDidDisappear:(BOOL)animated;
{
    [super viewDidDisappear:animated];
    self.scrollView.contentOffset = CGPointZero;
}

#pragma mark - Keyboard

//- (void)keyboardWillShow:(NSNotification *)notification;
//{
//    CGFloat keyboardHeight = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    NSInteger curve = [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
//    UIViewAnimationOptions options = (curve << 16);
//    
//    CGRect frame = self.view.frame;
//    frame.origin.y -= kTopBarHeight;
//    frame.origin.y -= (self.editingTag - 1) * kTextFieldMoveDistance;
//    
//    [UIView animateWithDuration:animationDuration
//                          delay:0.0
//                        options:options
//                     animations:^{
//                         self.view.frame = frame;
//                     } completion:nil];
//}

- (void)keyboardWillHide:(NSNotification *)notification;
{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    UIViewAnimationOptions options = (animationCurve << 16);
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:options
                     animations:^{
                         self.view.frame = self.originalFrame;
                     } completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    self.editingTag = textField.tag;
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    CGRect frame = self.originalFrame;
    frame.origin.y -= kTopBarHeight;
    frame.origin.y -= (self.editingTag - 1) * kTextFieldMoveDistance;
    
    [UIView animateWithDuration:0.33
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.frame = frame;
                     } completion:nil];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
}

//- (void)endEditing {
//    [self.view endEditing:YES];
//    CGRect frame = self.view.frame;
//    frame.origin.y = 64;
//    [UIView animateWithDuration:0.25 animations:^{
//        self.view.frame = frame;
//        if (!CGRectEqualToRect(_scrollViewFrame, CGRectNull)) {
//            self.scrollView.frame = _scrollViewFrame;
//        }
//        
//    }];
//}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
{
    
    if ([[segue identifier] isEqualToString:@"pushRNCartConfirmationViewController"] || [[segue identifier] isEqualToString:@"pushRNCartConfirmationViewControllerFromConfirm"]) {
        //
        // save info
        //
        
        RNUser *user = [[RNCart sharedCart] user];

        user.email = _emailTextField.text;
        user.fullName = _addressNameTextField.text;
        user.address = _addressStreetTextField.text;
        user.apt = _addressUnitTextField.text;
        user.city = _addressCityTextField.text;
        user.state = _addressStateTextField.text;
        user.zipCode = _addressZipTextField.text;
    }
}


- (IBAction)cartButtonTapped:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end


//  RNAuthViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/18/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNSkinableViewController.h"

@protocol RNAuthViewDelegate;


@interface RNAuthViewController : RNSkinableViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<RNAuthViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;

- (IBAction)backgroundTapped:(id)sender;
- (IBAction)signInTapped:(id)sender;
- (IBAction)forgotPasswordTapped:(id)sender;
- (IBAction)textFieldChanged:(UITextField *)sender;

@end


@protocol RNAuthViewDelegate <NSObject>
@optional

- (void)authViewController:(RNAuthViewController *)auth didFinish:(BOOL)success;
- (void)authViewControllerDidDismiss:(RNAuthViewController *)auth;

@end
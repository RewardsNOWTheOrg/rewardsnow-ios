//
//  RNAuthPasswordViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/18/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNSkinableViewController.h"

@interface RNAuthPasswordViewController : RNSkinableViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet CMTextField *answerTextField;
@property (weak, nonatomic) IBOutlet CMTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet CMTextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet CMTextField *usernameTextField;
@property (weak, nonatomic) IBOutlet CMTextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

- (IBAction)textDidChange:(UITextField *)sender;
- (IBAction)resetTapped:(id)sender;
@end

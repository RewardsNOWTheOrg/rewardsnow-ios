//
//  RNPreAuthViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/20/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNPreAuthViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *helperLabel;

- (IBAction)continueTapped:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)textFieldChanged:(UITextField *)sender;

@end

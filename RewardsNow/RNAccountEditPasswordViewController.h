//
//  RNAccountEditPasswordViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNSkinableViewController.h"

@interface RNAccountEditPasswordViewController : RNSkinableViewController

@property (weak, nonatomic) IBOutlet UITextField *passwordOldTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordNewTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordNewRetypeTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)saveTapped:(id)sender;
- (IBAction)textFieldChanged:(UITextField *)sender;

@end

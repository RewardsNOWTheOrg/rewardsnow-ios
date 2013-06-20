//
//  RNCartAccountViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNSkinableViewController.h"

@interface RNCartAccountViewController : RNSkinableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressStreetTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressUnitTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressCityStateTextField;
@property (weak, nonatomic) IBOutlet UISwitch *defaultEmailSwitch;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UILabel *topPointsLabel;
@property (weak, nonatomic) IBOutlet UIView *upperOuterView;
@property (weak, nonatomic) IBOutlet UIView *upperInnerView;
@property (weak, nonatomic) IBOutlet UIView *lowerOuterView;
@property (weak, nonatomic) IBOutlet UIView *lowerInnerView;

- (IBAction)cartButtonTapped:(id)sender;
@end

//
//  RNCartAccountViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNCartAccountViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressStreetTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressUnitTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressCityStateTextField;
@property (weak, nonatomic) IBOutlet UISwitch *defaultEmailSwitch;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UILabel *topPointsLabel;

@end

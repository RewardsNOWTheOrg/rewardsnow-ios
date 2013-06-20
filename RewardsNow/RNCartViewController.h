//
//  RNCartViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNSkinableViewController.h"

@interface RNCartViewController : RNSkinableViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *pointsAvailableLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsInCartLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *topPointsLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *innerViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *topButtonForward;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *skinnableLabels;

- (IBAction)confirmTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;
- (IBAction)stepperChanged:(UIStepper *)sender;

@end

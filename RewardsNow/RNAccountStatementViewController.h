//
//  RNAccountStatementViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNSkinableViewController.h"

@interface RNAccountStatementViewController : RNSkinableViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *pointsStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *displayedDetailView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *backMonthButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardMonthButton;
@property (weak, nonatomic) IBOutlet UIView *pointsAreaView;

- (IBAction)backMonth:(id)sender;
- (IBAction)forwardMonth:(id)sender;
- (IBAction)swipeRecognized:(id)sender;

@end

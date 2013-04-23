//
//  RNAccountStatementViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNAccountStatementViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *pointsStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *displayedDetailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableLeftSpace;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backMonth:(id)sender;
- (IBAction)forwardMonth:(id)sender;
- (IBAction)swipeRecognized:(id)sender;

@end

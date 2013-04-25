//
//  RNCartViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNCartViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *pointsAvailableLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsInCartLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLeftLabel;

- (IBAction)confirmTapped:(id)sender;

@end

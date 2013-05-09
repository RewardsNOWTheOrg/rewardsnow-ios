//
//  RNLocalViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RNLocalViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UILabel *topPointsLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)filterTapped:(id)sender;
- (IBAction)mapTapped:(id)sender;

@end

//
//  RNLocalFilterViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 5/20/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RNLocalFilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CLLocation *location;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *deals;

@end

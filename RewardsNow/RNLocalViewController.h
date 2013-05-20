//
//  RNLocalViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol RNLocalViewDelegate <NSObject>
- (void)refreshData;

@end

@interface RNLocalViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (nonatomic, weak) id<RNLocalViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *topPointsLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *deals;

@end

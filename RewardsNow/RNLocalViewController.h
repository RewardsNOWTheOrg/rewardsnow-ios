//
//  RNLocalViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WEPopoverController.h"
#import "RNSkinableViewController.h"
#import "RNPopoverViewController.h"

@protocol RNLocalViewDelegate <NSObject>

- (void)refreshDataWithRadius:(NSNumber *)radius;
- (void)setRadius:(NSNumber *)radius;
- (NSNumber *)radius;

@end

@interface RNLocalViewController : RNSkinableViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, PopoverControllerDelegate, RNPopoverDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) id<RNLocalViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *topPointsLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *deals;
@property (nonatomic) BOOL isPushed;

@end

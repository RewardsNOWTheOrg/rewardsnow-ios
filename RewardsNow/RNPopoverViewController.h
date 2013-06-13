//
//  RNPopoverViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 6/7/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RNPopoverDelegate <NSObject>

- (void)popoverDidFinishWithIndexPathSelected:(NSIndexPath *)indexPath;

@end

@interface RNPopoverViewController : UITableViewController

@property (nonatomic, weak) id<RNPopoverDelegate> delegate;

@end


//
//  RNLocalContainerViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 5/15/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RNLocalViewController.h"
#import "RNSkinableViewController.h"

@interface RNLocalContainerViewController : RNSkinableViewController <UITabBarControllerDelegate, CLLocationManagerDelegate, RNLocalViewDelegate>

@property (nonatomic, strong) UIViewController *displayedViewController;
@property (weak, nonatomic) IBOutlet UIView *containerView;


- (IBAction)mapTapped:(id)sender;
- (IBAction)filterTapped:(id)sender;
- (IBAction)listTapped:(id)sender;

@end

//
//  RNSkinableViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 5/31/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RNBranding;

@interface RNSkinableViewController : UIViewController

@property (nonatomic, strong) RNBranding *branding;

- (void)brand;

@end

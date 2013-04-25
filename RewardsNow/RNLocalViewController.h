//
//  RNLocalViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNLocalViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *topPointsLabel;

- (IBAction)filterTapped:(id)sender;
- (IBAction)mapTapped:(id)sender;

@end

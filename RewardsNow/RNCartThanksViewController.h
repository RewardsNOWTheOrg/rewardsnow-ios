//
//  RNCartThanksViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNCartThanksViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UIButton *thankYouButton;
@property (weak, nonatomic) IBOutlet UILabel *topPointsLabel;

- (IBAction)thankYouTapped:(id)sender;

@end

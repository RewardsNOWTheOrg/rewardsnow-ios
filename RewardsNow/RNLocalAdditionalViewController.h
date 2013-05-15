//
//  RNLocalAdditionalViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RNLocalDeal;

@interface RNLocalAdditionalViewController : UIViewController

@property (nonatomic, strong) RNLocalDeal *deal;
@property (weak, nonatomic) IBOutlet UILabel *upperTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperMiddleLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperLowerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)directionsTapped:(id)sender;
@end

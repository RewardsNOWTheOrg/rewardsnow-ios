//
//  RNLocalCell.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNLocalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *upperTitle;
@property (weak, nonatomic) IBOutlet UILabel *lowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondUpperLabel;
@property (weak, nonatomic) IBOutlet UILabel *textAreaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

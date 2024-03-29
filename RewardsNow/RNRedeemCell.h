//
//  RNRedeemCell.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNRedeemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *redeemImage;
@property (weak, nonatomic) IBOutlet UILabel *redeemTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *redeemBottomLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *flipBackgroundView;

@end

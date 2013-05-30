//
//  RNCartCell.m
//  RewardsNow
//
//  Created by Ethan Mick on 5/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNCartCell.h"

@implementation RNCartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if(highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithRed:C(149) green:C(149) blue:C(149) alpha:.3];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    [super setHighlighted:highlighted animated:animated];
}

@end

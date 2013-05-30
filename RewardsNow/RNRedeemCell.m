//
//  RNRedeemCell.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNRedeemCell.h"
#import "RNConstants.h"

#define kGrayIshColor [UIColor colorWithRed:C(233) green:C(236) blue:C(238) alpha:1.0]

@implementation RNRedeemCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ( (self = [super initWithCoder:aDecoder]) ) {
        self.contentView.backgroundColor = kGrayIshColor;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if(highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithRed:C(149) green:C(149) blue:C(149) alpha:.3];
    } else {
        self.contentView.backgroundColor = kGrayIshColor;
    }
    
    [super setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end

//
//  RNLabel.m
//  RewardsNow
//
//  Created by Ethan Mick on 9/22/14.
//  Copyright (c) 2014 CloudMine LLC. All rights reserved.
//

#import "RNLabel.h"

@implementation RNLabel

- (id)initWithCoder:(NSCoder *)aDecoder;
{
    if ( (self = [super initWithCoder:aDecoder]) ) {
        self.textInsets = [self defaultInsets];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textInsets = [self defaultInsets];
    }
    return self;
}

- (UIEdgeInsets)defaultInsets;
{
    return UIEdgeInsetsMake(0, 5, 0, 2);
}

- (void)drawTextInRect:(CGRect)rect;
{
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end

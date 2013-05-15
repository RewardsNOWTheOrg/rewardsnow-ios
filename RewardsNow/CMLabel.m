//
//  CMLabel.m
//  RewardsNow
//
//  Created by Ethan Mick on 5/14/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "CMLabel.h"

@implementation CMLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end

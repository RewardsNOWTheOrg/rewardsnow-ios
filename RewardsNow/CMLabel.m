//
//  CMLabel.m
//  RewardsNow
//
//  Created by Ethan Mick on 5/14/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "CMLabel.h"

@implementation CMLabel

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ( (self = [super initWithCoder:aDecoder]) ) {
        self.textInsets = [self defaultInsets];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textInsets = [self defaultInsets];
    }
    return self;
}

- (UIEdgeInsets)defaultInsets {
    return UIEdgeInsetsMake(0, 2, 0, 2);
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end

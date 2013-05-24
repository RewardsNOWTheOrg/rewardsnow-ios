//
//  RNAnimatedImageView.m
//  RewardsNow
//
//  Created by Ethan Mick on 5/24/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAnimatedImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RNAnimatedImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAnimationDidStopNotification object:self];
}



@end

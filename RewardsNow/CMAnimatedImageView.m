//
//  CMAnimatedImageView.m
//  RewardsNow
//
//  Created by Ethan Mick on 9/22/14.
//  Copyright (c) 2014 CloudMine LLC. All rights reserved.
//

#import "CMAnimatedImageView.h"

@implementation CMAnimatedImageView

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAnimationDidStopNotification object:self];
}

@end

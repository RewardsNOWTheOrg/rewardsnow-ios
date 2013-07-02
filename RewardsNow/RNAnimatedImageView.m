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

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAnimationDidStopNotification object:self];
}



@end

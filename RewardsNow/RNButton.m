//
//  RNButton.m
//  RewardsNow
//
//  Created by Ethan Mick on 6/13/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNButton.h"

@implementation RNButton


- (void)drawRect:(CGRect)rect {
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color7 = [UIColor colorWithRed: 0.055 green: 0.408 blue: 0.565 alpha: 1];
    UIColor* color5 = [UIColor colorWithRed: 0.027 green: 0.027 blue: 0.027 alpha: 0.2];
    UIColor* strokeColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.3];
    UIColor* color6 = [UIColor colorWithRed: 0.075 green: 0.584 blue: 0.812 alpha: 0.3];
    
    //// Shadow Declarations
    UIColor* shadow2 = strokeColor;
    CGSize shadow2Offset = CGSizeMake(0.1, -0.1);
    CGFloat shadow2BlurRadius = 3.5;
    
    //// RN_input Drawing
    UIBezierPath* rN_inputPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(11, 8, 528, 112) cornerRadius: 4];
    [color7 setFill];
    [rN_inputPath fill];
    
    ////// RN_input Inner Shadow
    CGRect rN_inputBorderRect = CGRectInset([rN_inputPath bounds], -shadow2BlurRadius, -shadow2BlurRadius);
    rN_inputBorderRect = CGRectOffset(rN_inputBorderRect, -shadow2Offset.width, -shadow2Offset.height);
    rN_inputBorderRect = CGRectInset(CGRectUnion(rN_inputBorderRect, [rN_inputPath bounds]), -1, -1);
    
    UIBezierPath* rN_inputNegativePath = [UIBezierPath bezierPathWithRect: rN_inputBorderRect];
    [rN_inputNegativePath appendPath: rN_inputPath];
    rN_inputNegativePath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    {
        CGFloat xOffset = shadow2Offset.width + round(rN_inputBorderRect.size.width);
        CGFloat yOffset = shadow2Offset.height;
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                    shadow2BlurRadius,
                                    shadow2.CGColor);
        
        [rN_inputPath addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(rN_inputBorderRect.size.width), 0);
        [rN_inputNegativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [rN_inputNegativePath fill];
    }
    CGContextRestoreGState(context);
    
    [color5 setStroke];
    rN_inputPath.lineWidth = 0.5;
    [rN_inputPath stroke];
    
    
    //// RN_input 2 Drawing
    UIBezierPath* rN_input2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(14.5, 11, 521, 105.5) cornerRadius: 4];
    [color6 setFill];
    [rN_input2Path fill];
}


@end

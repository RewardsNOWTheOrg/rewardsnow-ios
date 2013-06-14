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
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIColor* color = [UIColor colorWithRed: 0.114 green: 1 blue: 0.41 alpha: 1];
    UIColor* gradientColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* color4 = [UIColor colorWithRed: 0.667 green: 0.667 blue: 0.667 alpha: 1];
    UIColor* color5 = [UIColor colorWithRed: 0.027 green: 0.027 blue: 0.027 alpha: 0.2];
    UIColor* color6 = [UIColor colorWithRed: 0.075 green: 0.584 blue: 0.812 alpha: 1];
    UIColor* color7 = [UIColor colorWithRed: 0.055 green: 0.408 blue: 0.565 alpha: 1];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)gradientColor.CGColor,
                               (id)[UIColor colorWithRed: 0.833 green: 0.833 blue: 0.833 alpha: 1].CGColor,
                               (id)[UIColor lightGrayColor].CGColor, nil];
    CGFloat gradientLocations[] = {0, 0.49, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Shadow Declarations
    UIColor* shadow = color4;
    CGSize shadowOffset = CGSizeMake(0.1, -0.1);
    CGFloat shadowBlurRadius = 6;
    UIColor* shadow2 = strokeColor;
    CGSize shadow2Offset = CGSizeMake(0.1, -0.1);
    CGFloat shadow2BlurRadius = 3.5;
    UIColor* shadow4 = strokeColor;
    CGSize shadow4Offset = CGSizeMake(0.1, -0.1);
    CGFloat shadow4BlurRadius = 1;
    
    //// Frames
    CGRect frame = self.bounds; //CGRectMake(0, 0, 549.5, 130);
    
    
    //// RN_input Drawing
    UIBezierPath* rN_inputPath = [UIBezierPath bezierPath];
    [rN_inputPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 1, CGRectGetMaxY(frame) - 5)];
    [rN_inputPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 5, CGRectGetMaxY(frame) - 1) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 1, CGRectGetMaxY(frame) - 2.79) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 2.79, CGRectGetMaxY(frame) - 1)];
    [rN_inputPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 5, CGRectGetMaxY(frame) - 1)];
    [rN_inputPath addCurveToPoint: CGPointMake(CGRectGetMaxX(frame) - 1, CGRectGetMaxY(frame) - 5) controlPoint1: CGPointMake(CGRectGetMaxX(frame) - 2.79, CGRectGetMaxY(frame) - 1) controlPoint2: CGPointMake(CGRectGetMaxX(frame) - 1, CGRectGetMaxY(frame) - 2.79)];
    [rN_inputPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 1, CGRectGetMinY(frame) + 5)];
    [rN_inputPath addCurveToPoint: CGPointMake(CGRectGetMaxX(frame) - 5, CGRectGetMinY(frame) + 1) controlPoint1: CGPointMake(CGRectGetMaxX(frame) - 1, CGRectGetMinY(frame) + 2.79) controlPoint2: CGPointMake(CGRectGetMaxX(frame) - 2.79, CGRectGetMinY(frame) + 1)];
    [rN_inputPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 5, CGRectGetMinY(frame) + 1)];
    [rN_inputPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 1, CGRectGetMinY(frame) + 5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 2.79, CGRectGetMinY(frame) + 1) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 1, CGRectGetMinY(frame) + 2.79)];
    [rN_inputPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 1, CGRectGetMaxY(frame) - 5)];
    [rN_inputPath closePath];
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
    UIBezierPath* rN_input2Path = [UIBezierPath bezierPath];
    [rN_input2Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 5, CGRectGetMaxY(frame) - 8)];
    [rN_input2Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 9, CGRectGetMaxY(frame) - 4) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 5, CGRectGetMaxY(frame) - 5.79) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 6.79, CGRectGetMaxY(frame) - 4)];
    [rN_input2Path addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 8, CGRectGetMaxY(frame) - 4)];
    [rN_input2Path addCurveToPoint: CGPointMake(CGRectGetMaxX(frame) - 4, CGRectGetMaxY(frame) - 8) controlPoint1: CGPointMake(CGRectGetMaxX(frame) - 5.79, CGRectGetMaxY(frame) - 4) controlPoint2: CGPointMake(CGRectGetMaxX(frame) - 4, CGRectGetMaxY(frame) - 5.79)];
    [rN_input2Path addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 4, CGRectGetMinY(frame) + 8.5)];
    [rN_input2Path addCurveToPoint: CGPointMake(CGRectGetMaxX(frame) - 8, CGRectGetMinY(frame) + 4.5) controlPoint1: CGPointMake(CGRectGetMaxX(frame) - 4, CGRectGetMinY(frame) + 6.29) controlPoint2: CGPointMake(CGRectGetMaxX(frame) - 5.79, CGRectGetMinY(frame) + 4.5)];
    [rN_input2Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 9, CGRectGetMinY(frame) + 4.5)];
    [rN_input2Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 5, CGRectGetMinY(frame) + 8.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 6.79, CGRectGetMinY(frame) + 4.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 5, CGRectGetMinY(frame) + 6.29)];
    [rN_input2Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 5, CGRectGetMaxY(frame) - 8)];
    [rN_input2Path closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow4Offset, shadow4BlurRadius, shadow4.CGColor);
    [color6 setFill];
    [rN_input2Path fill];
    CGContextRestoreGState(context);
    
    
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(122.5, 107, 0, 0)];
    CGContextSaveGState(context);
    [ovalPath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(122.5, 107), CGPointMake(122.5, 107), 0);
    CGContextRestoreGState(context);
    
    ////// Oval Inner Shadow
    CGRect ovalBorderRect = CGRectInset([ovalPath bounds], -shadowBlurRadius, -shadowBlurRadius);
    ovalBorderRect = CGRectOffset(ovalBorderRect, -shadowOffset.width, -shadowOffset.height);
    ovalBorderRect = CGRectInset(CGRectUnion(ovalBorderRect, [ovalPath bounds]), -1, -1);
    
    UIBezierPath* ovalNegativePath = [UIBezierPath bezierPathWithRect: ovalBorderRect];
    [ovalNegativePath appendPath: ovalPath];
    ovalNegativePath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    {
        CGFloat xOffset = shadowOffset.width + round(ovalBorderRect.size.width);
        CGFloat yOffset = shadowOffset.height;
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                    shadowBlurRadius,
                                    shadow.CGColor);
        
        [ovalPath addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(ovalBorderRect.size.width), 0);
        [ovalNegativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [ovalNegativePath fill];
    }
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [color setStroke];
    ovalPath.lineWidth = 0.5;
    [ovalPath stroke];
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    

   
}


@end

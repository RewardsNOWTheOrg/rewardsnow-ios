//
//  RNTextField.m
//  RewardsNow
//
//  Created by Ethan Mick on 6/13/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNTextField.h"
#import "RNBranding.h"

@implementation RNTextField


- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ( (self = [super initWithCoder:aDecoder]) ) {
        self.shouldHaveDefaultColor = NO;
        self.textInsets = [self defaultInsets];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textInsets = [self defaultInsets];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return self;
}

- (UIEdgeInsets)defaultInsets;
{
    return UIEdgeInsetsMake(0, 5, 0, 2);
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds;
{
    return UIEdgeInsetsInsetRect(bounds, _textInsets);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds;
{
    return UIEdgeInsetsInsetRect(bounds, _textInsets);
}


- (void)drawRect:(CGRect)rect {
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
//    UIRectFill(self.bounds);
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.114 green: 1 blue: 0.41 alpha: 1];
    UIColor* gradientColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor *color3 = _shouldHaveDefaultColor ? [UIColor colorWithRed: 0.286 green: 0.353 blue: 0.408 alpha: 0.2] : [[RNBranding sharedBranding] pointsColor];
    UIColor* color4 = [UIColor colorWithRed: 0.667 green: 0.667 blue: 0.667 alpha: 1];
    UIColor* color5 = [UIColor colorWithRed: 0.027 green: 0.027 blue: 0.027 alpha: 0.2];
    
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
    
    //// Frames
    CGRect frame = self.bounds; //CGRectMake(0, 0, 550, 130);
    
    
    //// RN_input Drawing
    UIBezierPath* rN_inputPath = [UIBezierPath bezierPath];
    [rN_inputPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 3, CGRectGetMaxY(frame) - 7)];
    [rN_inputPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 7, CGRectGetMaxY(frame) - 3) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 3, CGRectGetMaxY(frame) - 4.79) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 4.79, CGRectGetMaxY(frame) - 3)];
    [rN_inputPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 7, CGRectGetMaxY(frame) - 3)];
    [rN_inputPath addCurveToPoint: CGPointMake(CGRectGetMaxX(frame) - 3, CGRectGetMaxY(frame) - 7) controlPoint1: CGPointMake(CGRectGetMaxX(frame) - 4.79, CGRectGetMaxY(frame) - 3) controlPoint2: CGPointMake(CGRectGetMaxX(frame) - 3, CGRectGetMaxY(frame) - 4.79)];
    [rN_inputPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 3, CGRectGetMinY(frame) + 6.5)];
    [rN_inputPath addCurveToPoint: CGPointMake(CGRectGetMaxX(frame) - 7, CGRectGetMinY(frame) + 2.5) controlPoint1: CGPointMake(CGRectGetMaxX(frame) - 3, CGRectGetMinY(frame) + 4.29) controlPoint2: CGPointMake(CGRectGetMaxX(frame) - 4.79, CGRectGetMinY(frame) + 2.5)];
    [rN_inputPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 7, CGRectGetMinY(frame) + 2.5)];
    [rN_inputPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 3, CGRectGetMinY(frame) + 6.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 4.79, CGRectGetMinY(frame) + 2.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 3, CGRectGetMinY(frame) + 4.29)];
    [rN_inputPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 3, CGRectGetMaxY(frame) - 7)];
    [rN_inputPath closePath];
    [color3 setFill];
    [rN_inputPath fill];
    
    ////// RN_input Inner Shadow
    CGRect rN_inputBorderRect = CGRectInset([rN_inputPath bounds], -shadowBlurRadius, -shadowBlurRadius);
    rN_inputBorderRect = CGRectOffset(rN_inputBorderRect, -shadowOffset.width, -shadowOffset.height);
    rN_inputBorderRect = CGRectInset(CGRectUnion(rN_inputBorderRect, [rN_inputPath bounds]), -1, -1);
    
    UIBezierPath* rN_inputNegativePath = [UIBezierPath bezierPathWithRect: rN_inputBorderRect];
    [rN_inputNegativePath appendPath: rN_inputPath];
    rN_inputNegativePath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    {
        CGFloat xOffset = shadowOffset.width + round(rN_inputBorderRect.size.width);
        CGFloat yOffset = shadowOffset.height;
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                    shadowBlurRadius,
                                    shadow.CGColor);
        
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

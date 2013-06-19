//
//  RNLeftArrow.m
//  RewardsNow
//
//  Created by Ethan Mick on 6/19/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNLeftArrow.h"
#import "RNBranding.h"

@implementation RNLeftArrow

- (id)initWithFrame:(CGRect)frame
{
    if ( (self = [super initWithFrame:frame]) ) {
        [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ( (self = [super initWithCoder:aDecoder]) ) {
        [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"highlighted"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    // Down
    if (self.isHighlighted) {
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* fillColor = [[RNBranding sharedBranding] menuBackgroundColor]; //[UIColor colorWithRed: 0.106 green: 0.565 blue: 0.769 alpha: 1];
        UIColor* strokeColor = [[RNBranding sharedBranding] menuBackgroundColor]; //[UIColor colorWithRed: 0.063 green: 0.424 blue: 0.584 alpha: 1];
        UIColor* color2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.75];
        UIColor* fillColor2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
        UIColor* strokeColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
        
        //// Gradient Declarations
        NSArray* gradientColors = [NSArray arrayWithObjects:
                                   (id)fillColor.CGColor,
                                   (id)strokeColor.CGColor, nil];
        CGFloat gradientLocations[] = {0, 1};
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
        
        //// Shadow Declarations
        UIColor* shadow = color2;
        CGSize shadowOffset = CGSizeMake(-1.1, 2.1);
        CGFloat shadowBlurRadius = 5;
        UIColor* shadow2 = strokeColor2;
        CGSize shadow2Offset = CGSizeMake(0.1, 1.1);
        CGFloat shadow2BlurRadius = 1;
        
        //// Group
        {
            //// Rounded Rectangle Drawing
            UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPath];
            [roundedRectanglePath moveToPoint: CGPointMake(0.25, 26.79)];
            [roundedRectanglePath addCurveToPoint: CGPointMake(2.22, 28.75) controlPoint1: CGPointMake(0.25, 27.87) controlPoint2: CGPointMake(1.13, 28.75)];
            [roundedRectanglePath addLineToPoint: CGPointMake(29.78, 28.75)];
            [roundedRectanglePath addCurveToPoint: CGPointMake(31.75, 26.79) controlPoint1: CGPointMake(30.87, 28.75) controlPoint2: CGPointMake(31.75, 27.87)];
            [roundedRectanglePath addLineToPoint: CGPointMake(31.75, 2.21)];
            [roundedRectanglePath addCurveToPoint: CGPointMake(29.78, 0.25) controlPoint1: CGPointMake(31.75, 1.13) controlPoint2: CGPointMake(30.87, 0.25)];
            [roundedRectanglePath addLineToPoint: CGPointMake(2.22, 0.25)];
            [roundedRectanglePath addCurveToPoint: CGPointMake(0.25, 2.21) controlPoint1: CGPointMake(1.13, 0.25) controlPoint2: CGPointMake(0.25, 1.13)];
            [roundedRectanglePath addLineToPoint: CGPointMake(0.25, 26.79)];
            [roundedRectanglePath closePath];
            CGContextSaveGState(context);
            [roundedRectanglePath addClip];
            CGContextDrawLinearGradient(context, gradient, CGPointMake(16, 0.25), CGPointMake(16, 28.75), 0);
            CGContextRestoreGState(context);
            
            ////// Rounded Rectangle Inner Shadow
            CGRect roundedRectangleBorderRect = CGRectInset([roundedRectanglePath bounds], -shadowBlurRadius, -shadowBlurRadius);
            roundedRectangleBorderRect = CGRectOffset(roundedRectangleBorderRect, -shadowOffset.width, -shadowOffset.height);
            roundedRectangleBorderRect = CGRectInset(CGRectUnion(roundedRectangleBorderRect, [roundedRectanglePath bounds]), -1, -1);
            
            UIBezierPath* roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect: roundedRectangleBorderRect];
            [roundedRectangleNegativePath appendPath: roundedRectanglePath];
            roundedRectangleNegativePath.usesEvenOddFillRule = YES;
            
            CGContextSaveGState(context);
            {
                CGFloat xOffset = shadowOffset.width + round(roundedRectangleBorderRect.size.width);
                CGFloat yOffset = shadowOffset.height;
                CGContextSetShadowWithColor(context,
                                            CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                            shadowBlurRadius,
                                            shadow.CGColor);
                
                [roundedRectanglePath addClip];
                CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(roundedRectangleBorderRect.size.width), 0);
                [roundedRectangleNegativePath applyTransform: transform];
                [[UIColor grayColor] setFill];
                [roundedRectangleNegativePath fill];
            }
            CGContextRestoreGState(context);
            
            [color2 setStroke];
            roundedRectanglePath.lineWidth = 0.5;
            [roundedRectanglePath stroke];
            
            
            //// Bezier Drawing
            UIBezierPath* bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint: CGPointMake(20.43, 8.11)];
            [bezierPath addLineToPoint: CGPointMake(9.6, 14.5)];
            [bezierPath addLineToPoint: CGPointMake(20.43, 20.89)];
            [bezierPath addLineToPoint: CGPointMake(20.43, 8.11)];
            [bezierPath closePath];
            [fillColor2 setFill];
            [bezierPath fill];
            
            ////// Bezier Inner Shadow
            CGRect bezierBorderRect = CGRectInset([bezierPath bounds], -shadow2BlurRadius, -shadow2BlurRadius);
            bezierBorderRect = CGRectOffset(bezierBorderRect, -shadow2Offset.width, -shadow2Offset.height);
            bezierBorderRect = CGRectInset(CGRectUnion(bezierBorderRect, [bezierPath bounds]), -1, -1);
            
            UIBezierPath* bezierNegativePath = [UIBezierPath bezierPathWithRect: bezierBorderRect];
            [bezierNegativePath appendPath: bezierPath];
            bezierNegativePath.usesEvenOddFillRule = YES;
            
            CGContextSaveGState(context);
            {
                CGFloat xOffset = shadow2Offset.width + round(bezierBorderRect.size.width);
                CGFloat yOffset = shadow2Offset.height;
                CGContextSetShadowWithColor(context,
                                            CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                            shadow2BlurRadius,
                                            shadow2.CGColor);
                
                [bezierPath addClip];
                CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(bezierBorderRect.size.width), 0);
                [bezierNegativePath applyTransform: transform];
                [[UIColor grayColor] setFill];
                [bezierNegativePath fill];
            }
            CGContextRestoreGState(context);
            
        }
        
        
        //// Cleanup
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        

        
        
    } else {
        
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* fillColor = [[RNBranding sharedBranding] menuBackgroundColor]; //[UIColor colorWithRed: 0.106 green: 0.565 blue: 0.769 alpha: 1];
        UIColor* strokeColor = [[RNBranding sharedBranding] menuBackgroundColor]; //[UIColor colorWithRed: 0.063 green: 0.424 blue: 0.584 alpha: 1];
        UIColor* color2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.75];
        UIColor* fillColor2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
        
        //// Gradient Declarations
        NSArray* gradientColors = [NSArray arrayWithObjects:
                                   (id)fillColor.CGColor,
                                   (id)strokeColor.CGColor, nil];
        CGFloat gradientLocations[] = {0, 1};
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
        
        //// Group
        {
            //// Rounded Rectangle Drawing
            UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPath];
            [roundedRectanglePath moveToPoint: CGPointMake(0.25, 26.79)];
            [roundedRectanglePath addCurveToPoint: CGPointMake(2.22, 28.75) controlPoint1: CGPointMake(0.25, 27.87) controlPoint2: CGPointMake(1.13, 28.75)];
            [roundedRectanglePath addLineToPoint: CGPointMake(29.78, 28.75)];
            [roundedRectanglePath addCurveToPoint: CGPointMake(31.75, 26.79) controlPoint1: CGPointMake(30.87, 28.75) controlPoint2: CGPointMake(31.75, 27.87)];
            [roundedRectanglePath addLineToPoint: CGPointMake(31.75, 2.21)];
            [roundedRectanglePath addCurveToPoint: CGPointMake(29.78, 0.25) controlPoint1: CGPointMake(31.75, 1.13) controlPoint2: CGPointMake(30.87, 0.25)];
            [roundedRectanglePath addLineToPoint: CGPointMake(2.22, 0.25)];
            [roundedRectanglePath addCurveToPoint: CGPointMake(0.25, 2.21) controlPoint1: CGPointMake(1.13, 0.25) controlPoint2: CGPointMake(0.25, 1.13)];
            [roundedRectanglePath addLineToPoint: CGPointMake(0.25, 26.79)];
            [roundedRectanglePath closePath];
            CGContextSaveGState(context);
            [roundedRectanglePath addClip];
            CGContextDrawLinearGradient(context, gradient, CGPointMake(16, 0.25), CGPointMake(16, 28.75), 0);
            CGContextRestoreGState(context);
            [color2 setStroke];
            roundedRectanglePath.lineWidth = 0.5;
            [roundedRectanglePath stroke];
            
            
            //// Bezier Drawing
            UIBezierPath* bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint: CGPointMake(20.43, 20.89)];
            [bezierPath addLineToPoint: CGPointMake(9.6, 14.5)];
            [bezierPath addLineToPoint: CGPointMake(20.43, 8.11)];
            [bezierPath addLineToPoint: CGPointMake(20.43, 20.89)];
            [bezierPath closePath];
            [fillColor2 setFill];
            [bezierPath fill];
        }
        
        
        //// Cleanup
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        
        

        

    }
    
    
}


@end

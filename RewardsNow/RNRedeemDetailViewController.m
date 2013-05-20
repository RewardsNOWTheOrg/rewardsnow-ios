//
//  RNRedeemDetailViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNRedeemDetailViewController.h"
#import "RNConstants.h"
#import "RNRedeemCell.h"
#import "RNRedeemObject.h"
#import "RNCart.h"
#import <QuartzCore/QuartzCore.h>


@interface RNRedeemDetailViewController ()

@end

@implementation RNRedeemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.descriptionView.layer.cornerRadius = 5.0;
    
    self.redeemImage.image = self.info.image;
    self.redeemTopLabel.text = [NSString stringWithFormat:@"$%d", (NSInteger)self.info.cashValue];
    self.redeemBottomLabel.text = [NSString stringWithFormat:@"%d Points", (NSInteger)_info.priceInPoints];
    self.descriptionTextView.text = self.info.catagoryDescription;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    ///
    /// On the fly resizing of components.
    ///
    CGFloat origDiff = _descriptionView.frame.size.height - _descriptionTextView.frame.size.height;
    
    NSString *details = _info.catagoryDescription;
    CGSize size = [details sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(_descriptionTextView.frame.size.width, INFINITY) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame = _descriptionTextView.frame;
    frame.size.height = size.height + 40;
    _descriptionTextView.frame = frame;
    
    frame = _descriptionView.frame;
    frame.size.height = _descriptionTextView.frame.size.height + origDiff;
    _descriptionView.frame = frame;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:self.innerView.frame.size];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.scrollView.contentOffset = CGPointZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)addToCartTapped:(id)sender {
    [[RNCart sharedCart] addToCart:_info];

}

- (void)animateCartAdd {
    UIImageView *imageViewForAnimation = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart-full.png"]];
    imageViewForAnimation.frame = CGRectMake(200, 160, 25, 25);
    imageViewForAnimation.alpha = 1.0f;
    CGRect imageFrame = imageViewForAnimation.frame;
    //Your image frame.origin from where the animation need to get start
    CGPoint viewOrigin = imageViewForAnimation.frame.origin;
    viewOrigin.y = viewOrigin.y + imageFrame.size.height / 2.0f;
    viewOrigin.x = viewOrigin.x + imageFrame.size.width / 2.0f;
    
    imageViewForAnimation.frame = imageFrame;
    imageViewForAnimation.layer.position = viewOrigin;
    [self.view addSubview:imageViewForAnimation];
    
    // Set up fade out effect
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.3]];
    fadeOutAnimation.fillMode = kCAFillModeForwards;
    fadeOutAnimation.removedOnCompletion = NO;
    
    // Set up scaling
    CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    [resizeAnimation setToValue:[NSValue valueWithCGSize:CGSizeMake(40.0f, imageFrame.size.height * (40.0f / imageFrame.size.width))]];
    resizeAnimation.fillMode = kCAFillModeForwards;
    resizeAnimation.removedOnCompletion = NO;
    
    // Set up path movement
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    //Setting Endpoint of the animation
    CGPoint endPoint = CGPointMake(300.0f, 10.0f);
    //to end animation in last tab use
    //CGPoint endPoint = CGPointMake( 320-40.0f, 480.0f);
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, viewOrigin.x, viewOrigin.y);
    CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, viewOrigin.y, endPoint.x, viewOrigin.y, endPoint.x, endPoint.y);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setAnimations:[NSArray arrayWithObjects:fadeOutAnimation, pathAnimation, resizeAnimation, nil]];
    group.duration = 0.7f;
    group.delegate = self;
    [group setValue:imageViewForAnimation forKey:@"imageViewBeingAnimated"];
    
    [imageViewForAnimation.layer addAnimation:group forKey:@"savingAnimation"];
}
@end

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

@property (nonatomic, strong) UIImageView *animatedImageView;

@end

@implementation RNRedeemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.descriptionView.layer.cornerRadius = 5.0;
    
    self.redeemImage.image = self.info.image;
    self.redeemTopLabel.text = [NSString stringWithFormat:@"$%d eGift Card", (NSInteger)self.info.cashValue];
    self.redeemBottomLabel.text = [NSString stringWithFormat:@"%@ Points", _info.stringPriceInPoints];
    self.descriptionTextView.text = self.info.catagoryDescription;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:[[RNCart sharedCart] getCartImageName]]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(goToCart:)];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    _descriptionTextView.frame = CGRectMake(6, 47, 298, 100);
    CGFloat height = _descriptionTextView.contentSize.height;
    DLog(@"Height: %f", height);
    _innerViewHeight.constant = height + 300;
    [self.view layoutIfNeeded];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:self.innerView.frame.size];
//    
//    DLog(@"Height: %f", _descriptionTextView.frame.size.height);
//    
//    CGFloat height = _descriptionTextView.contentSize.height;
//    DLog(@"Height: %f", height);
////    _innerInnerViewHeight.constant = height;
//    [self.view layoutIfNeeded];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.scrollView.contentOffset = CGPointZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)goToCart:(id)sender {
    [self performSegueWithIdentifier:@"modalCartFromRedeemDetail" sender:self];
}

- (IBAction)addToCartTapped:(id)sender {
    [self animateCartAdd];
    self.addToCartButton.enabled = NO;
    [[RNCart sharedCart] addToCart:_info];
}

- (void)animateCartAdd {
    self.animatedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thank-you-button"]];
    
    CGPoint center = [_addToCartButton.superview convertPoint:_addToCartButton.center toView:nil];
    
    _animatedImageView.frame = CGRectMake(160, 190, 25, 25);
    _animatedImageView.center = center;
    _animatedImageView.alpha = 1.0f;
    CGRect imageFrame = _animatedImageView.frame;
    
    //Your image frame.origin from where the animation need to get start
    CGPoint viewOrigin = _animatedImageView.frame.origin;
    viewOrigin.y = viewOrigin.y + imageFrame.size.height / 2.0f;
    viewOrigin.x = viewOrigin.x + imageFrame.size.width / 2.0f;
    
    _animatedImageView.frame = imageFrame;
    _animatedImageView.layer.position = viewOrigin;
    [self.navigationController.view addSubview:_animatedImageView];
    
    // Set up path movement
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    //Setting Endpoint of the animation
    CGPoint endPoint = CGPointMake(290.0f, 35.0f);
    //to end animation in last tab use
    //CGPoint endPoint = CGPointMake( 320-40.0f, 480.0f);
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, viewOrigin.x, viewOrigin.y);
//    CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, viewOrigin.y, endPoint.x, viewOrigin.y, endPoint.x, endPoint.y);
    CGPathAddCurveToPoint(curvedPath, NULL, 200, 50, 200, 50, endPoint.x, endPoint.y);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setAnimations:[NSArray arrayWithObjects:/*fadeOutAnimation, pathAnimation,*/ pathAnimation, nil]];
    
    CGFloat xDist = (endPoint.x - viewOrigin.x);
    CGFloat yDist = (endPoint.y - viewOrigin.y);
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    group.duration = distance / 300.0;
    group.delegate = self;
    [group setValue:_animatedImageView forKey:@"imageViewBeingAnimated"];
    
    [_animatedImageView.layer addAnimation:group forKey:@"savingAnimation"];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
    DLog(@"Animation Finished");
    self.addToCartButton.enabled = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:[[RNCart sharedCart] getCartImageName]]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(goToCart:)];
    
    if (finished) {
        [_animatedImageView removeFromSuperview];
    }
}
@end

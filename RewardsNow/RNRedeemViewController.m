//
//  RNRedeemViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNRedeemViewController.h"
#import "RNRedeemCell.h"
#import "RNWebService.h"
#import "UIImageView+AFNetworking.h"
#import "RNConstants.h"
#import "RNRedeemDetailViewController.h"
#import "RNRedeemObject.h"
#import "RNAuthViewController.h"
#import "RNCart.h"
#import "RNUser.h"
#import "RNAnimatedImageView.h"
#import "RNResponse.h"
#import <QuartzCore/QuartzCore.h>

@interface RNRedeemViewController ()

@property (nonatomic, strong) NSArray *rewards;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *animatedImages;

@end

@implementation RNRedeemViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.rewards = [NSArray array];
    self.animatedImages = [NSMutableArray array];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshControl];
    [_refreshControl beginRefreshing];
    [self refresh:_refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.topPointsLabel.text = [[RNCart sharedCart] getNamePoints];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:[[RNCart sharedCart] getCartImageName]]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(goToCart:)];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    for (UIImageView *view in _animatedImages) {
        [view.layer removeAllAnimations];
        [view removeFromSuperview];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refresh:(UIRefreshControl *)sender {
    
    [[RNWebService sharedClient] getRewardsWithCallback:^(RNResponse *response) {
        
        if ([response wasSuccessful]) {
            self.rewards = response.result;
            [self.tableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:response.errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
        [sender endRefreshing];
    }];
}

- (void)goToCart:(id)sender {
    [self performSegueWithIdentifier:@"modalCartFromRedeemList" sender:self];
}

#pragma mark - UITableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rewards count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"RedeemCell";
    
    RNRedeemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.redeemTopLabel.text = [NSString stringWithFormat:@"%@ pts for $%d", [self.rewards[indexPath.row] stringPriceInPoints], (NSInteger)[self.rewards[indexPath.row] cashValue]];
    cell.redeemBottomLabel.text = [self.rewards[indexPath.row] catagoryDescription];
    cell.redeemImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.addButton.tag = indexPath.row;
    [cell.addButton addTarget:self action:@selector(addToCartButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[self.rewards[indexPath.row] imageURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [cell.redeemImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.redeemImage.image = image;
        [self.rewards[indexPath.row] setImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        DLog(@"Failed to get image!");
    }];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"Clicked: %@", _rewards[indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if ([[segue identifier] isEqualToString:@"RedeemCellPush"]) {
        RNRedeemDetailViewController *detail = [segue destinationViewController];
        detail.info = self.rewards[indexPath.row];
    }
}

- (void)addToCartButtonPressed:(UIButton *)sender {
    [[RNCart sharedCart] addToCart:_rewards[[sender tag]]];
    
    RNRedeemCell *cell = (RNRedeemCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    
    CGPoint center = [sender.superview convertPoint:sender.superview.center toView:nil];
    center.x = 40;
    
    ///
    /// If the cart has nothing in it, then the first time they add something change the icon after the animation is done
    ///
    DLog(@"Count: %d", [[RNCart sharedCart] items].count);
    if ([[RNCart sharedCart] items].count == 1) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationDidFinishWithNotification:) name:kAnimationDidStopNotification object:nil];
    }
    
    
    [self flipView:cell.redeemImage fromCenter:center];
}

#pragma mark - Animations

- (void)animationDidFinishWithNotification:(NSNotification *)note {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:[[RNCart sharedCart] getCartImageName]]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(goToCart:)];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)flipView:(UIView *)view fromCenter:(CGPoint)center {
    
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    backView.image = [UIImage imageNamed:@"thank-you-button"];

    [UIView transitionFromView:view toView:backView duration:0.25 options:UIViewAnimationOptionTransitionFlipFromTop completion:^(BOOL finished) {
        
        [self animateCartAddFromPoint:center];
        [UIView transitionFromView:backView toView:view duration:0.25 options:UIViewAnimationOptionTransitionFlipFromTop completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)animateCartAddFromPoint:(CGPoint )point {
    
    
    RNAnimatedImageView *animatedImage = [[RNAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"thank-you-button"]];
    [_animatedImages addObject:animatedImage];
    
    animatedImage.frame = CGRectMake(160, 190, 25, 25);
    animatedImage.center = point;
    animatedImage.alpha = 1.0f;
    CGRect imageFrame = animatedImage.frame;
    
    //Your image frame.origin from where the animation need to get start
    CGPoint viewOrigin = animatedImage.frame.origin;
    viewOrigin.y = viewOrigin.y + imageFrame.size.height / 2.0f;
    viewOrigin.x = viewOrigin.x + imageFrame.size.width / 2.0f;
    
    animatedImage.frame = imageFrame;
    animatedImage.layer.position = viewOrigin;
    [self.navigationController.view addSubview:animatedImage];
    
    ///
    /// Set up the Path Movement
    ///
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
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
    [group setAnimations:[NSArray arrayWithObjects:/*fadeOutAnimation, pathAnimation,*/ pathAnimation, nil]]; //don't need group anymore...
    
    CGFloat xDist = (endPoint.x - viewOrigin.x);
    CGFloat yDist = (endPoint.y - viewOrigin.y);
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    group.duration = distance / 300.0;
    group.delegate = animatedImage;
    [group setValue:animatedImage forKey:@"imageViewBeingAnimated"];
    
    [animatedImage.layer addAnimation:group forKey:@"savingAnimation"];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
    DLog(@"Animation Finished");
    
    
    
    if (finished) {
//        [animation. removeFromSuperview];
    }
}

@end

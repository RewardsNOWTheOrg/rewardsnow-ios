//
//  RNLocalContainerViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 5/15/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNLocalContainerViewController.h"

@interface RNLocalContainerViewController ()

@end

@implementation RNLocalContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_displayedViewController == nil) {
        _displayedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalViewController"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.containerView.backgroundColor = [UIColor redColor];
    
    DLog(@"Frame: %@", NSStringFromCGRect(self.containerView.frame));
    
    if (_displayedViewController != nil) {
        [self addChildViewController:_displayedViewController];
        [self.containerView addSubview:_displayedViewController.view];
        CGRect frame = _displayedViewController.view.frame;
        frame.origin.y = 0;
        _displayedViewController.view.frame = frame;
//        _displayedViewController.view.frame = CGRectMake(0, 0, _containerView.frame.size.width, _containerView.frame.size.height);
//        [self.displayedViewController didMoveToParentViewController:self];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    DLog(@"Frame: %@", NSStringFromCGRect(self.containerView.frame));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)transitionFromCurrentViewControllerToViewController:(UIViewController *)vc options:(UIViewAnimationOptions)options {
    
    CGRect frame = vc.view.frame;
    frame.origin.y = 0;
    vc.view.frame = frame;
    
    [self addChildViewController:vc];
    
    [self transitionFromViewController:_displayedViewController
                      toViewController:vc
                              duration:1.0
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:nil
                            completion:^(BOOL finished) {
                                [vc didMoveToParentViewController:self];
                                self.displayedViewController = vc;
                                
                            }];
}

- (IBAction)mapTapped:(id)sender {
    UIViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalMapViewController"];
    [self transitionFromCurrentViewControllerToViewController:newController options:UIViewAnimationOptionTransitionFlipFromLeft];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector(listTapped:)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    
}

- (IBAction)filterTapped:(id)sender {
    
}

- (IBAction)listTapped:(id)sender {
    UIViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalViewController"];
    [self transitionFromCurrentViewControllerToViewController:newController options:UIViewAnimationOptionTransitionFlipFromLeft];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(mapTapped:)];
    self.navigationItem.rightBarButtonItem = barButton;
}

@end

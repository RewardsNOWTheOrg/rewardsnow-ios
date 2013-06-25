//
//  RNLocalContainerViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 5/15/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNLocalContainerViewController.h"
#import "RNLocalMapViewController.h"
#import "RNLocalFilterViewController.h"
#import "RNWebService.h"
#import "RNConstants.h"

@interface RNLocalContainerViewController ()

@property (nonatomic, strong) RNLocalMapViewController *mapViewController;
@property (nonatomic, strong) RNLocalViewController *listViewController;
@property (nonatomic, strong) RNLocalFilterViewController *filterViewController;
@property (nonatomic) BOOL isVisible;
@property (nonatomic, copy) NSArray *deals;
@property (nonatomic, strong) CLLocationManager *manager;
@property (atomic) BOOL gettingInformation;
@property (nonatomic, strong) NSNumber *radius;

@end

@implementation RNLocalContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gettingInformation = NO;
    self.radius = [self defaultRadius];
    
    if (_displayedViewController == nil) {
        self.listViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalViewController"];
        self.listViewController.delegate = self;
        _displayedViewController = self.listViewController;
    }
    
    self.manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    _manager.distanceFilter = kCLDistanceFilterNone;
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    [_manager startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.delegate = self;
    
    self.containerView.backgroundColor = [UIColor redColor];
    
    if (_displayedViewController != nil) {
        [self addChildViewController:_displayedViewController];
        [self.containerView addSubview:_displayedViewController.view];
        [self.displayedViewController didMoveToParentViewController:self];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isVisible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.delegate = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.isVisible = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect frame = _displayedViewController.view.frame;
    frame.origin.y = 0;
    frame.size.height = _containerView.frame.size.height;
    _displayedViewController.view.frame = frame;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSNumber *)defaultRadius {
    return [RNConstants radii][0];
}

- (void)transitionFromCurrentViewControllerToViewController:(UIViewController *)vc options:(UIViewAnimationOptions)options {
    
    CGRect frame = vc.view.frame;
    frame.origin.y = 0;
    frame.size.height = _containerView.frame.size.height;
    vc.view.frame = frame;
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
    [self addChildViewController:vc];
    [self transitionFromViewController:_displayedViewController
                      toViewController:vc
                              duration:1.0
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:nil
                            completion:^(BOOL finished) {
                                [vc didMoveToParentViewController:self];
                                self.displayedViewController = vc;
                                self.navigationController.navigationBar.userInteractionEnabled = YES;
                            }];
}

- (IBAction)mapTapped:(id)sender {
    
    if (_mapViewController == nil) {
        self.mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalMapViewController"];
        self.mapViewController.deals = _deals;
        self.mapViewController.location = [[_manager location] coordinate];
    }
    
    self.title = @"Map";
    [self transitionFromCurrentViewControllerToViewController:_mapViewController options:UIViewAnimationOptionTransitionFlipFromLeft];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector(listTapped:)];
    self.navigationItem.rightBarButtonItem = barButton;
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterTapped:)];
    self.navigationItem.leftBarButtonItem = filterButton;
}

- (IBAction)filterTapped:(id)sender {
    
    if (_filterViewController == nil) {
        self.filterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalFilterViewController"];
        self.filterViewController.location = _manager.location;
    }
    
    self.title = @"Filter";
    
    [self transitionFromCurrentViewControllerToViewController:_filterViewController options:UIViewAnimationOptionTransitionFlipFromLeft];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector(listTapped:)];
    self.navigationItem.leftBarButtonItem = barButton;
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(mapTapped:)];
    self.navigationItem.rightBarButtonItem = mapButton;
}

- (IBAction)listTapped:(id)sender {
    
    if (_listViewController == nil) {
        self.listViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalViewController"];
    }
    self.title = @"Deals";
    
    self.deals = _deals;
    
    BOOL right = [_displayedViewController isKindOfClass:[RNLocalMapViewController class]];
    [self transitionFromCurrentViewControllerToViewController:_listViewController options:UIViewAnimationOptionTransitionFlipFromRight];
    
    if (right) {
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(mapTapped:)];
        self.navigationItem.rightBarButtonItem = barButton;
    } else {
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterTapped:)];
        self.navigationItem.leftBarButtonItem = barButton;
    }
}

#pragma UITabBarController Delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    DLog(@"Class: %@", viewController.class);
    
    if ([viewController isKindOfClass:[UINavigationController class]] &&
        ((UINavigationController *)viewController).viewControllers.count > 0 &&
        ((UINavigationController *)viewController).viewControllers[0] == self &&
        _displayedViewController != self.listViewController &&
        _isVisible ) {
        [self listTapped:nil];
    }
}

#pragma mark - RNLocalViewDelegate

- (void)refreshDataWithRadius:(NSNumber *)radius {
    
    if (radius != nil) {
        self.radius = radius;
    }
    
    
    self.gettingInformation = NO;
    [_manager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    
    if (!_gettingInformation) {
        self.gettingInformation = YES;
        [[RNWebService sharedClient] getDealsAtLocation:location query:@"" limit:50 offset:0 radius:_radius.doubleValue category:nil callback:^(id result) {
            if (result != nil) {
                self.deals = result;
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"The content could not be correctly fetched." delegate:nil cancelButtonTitle:@"Okay." otherButtonTitles:nil] show];
            }
            
            if (self.displayedViewController == self.mapViewController) { //kind hackish :/
                self.mapViewController.location = location.coordinate;
            }
            [(RNLocalMapViewController *)self.displayedViewController setDeals:_deals]; //they all have this property
            self.gettingInformation = NO;
        }];
    }
    
    [manager stopUpdatingLocation];
}


@end

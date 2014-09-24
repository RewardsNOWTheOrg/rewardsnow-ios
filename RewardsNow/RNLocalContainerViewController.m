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
#import "RNResponse.h"
#import "RNCart.h"
#import "RNUser.h"

@interface RNLocalContainerViewController ()

@property (nonatomic, strong) RNLocalMapViewController *mapViewController;
@property (nonatomic, strong) RNLocalViewController *listViewController;
@property (nonatomic, strong) RNLocalFilterViewController *filterViewController;
@property (nonatomic) BOOL isVisible;
@property (nonatomic, copy) NSArray *deals;
@property (nonatomic, strong) CLLocationManager *manager;
@property (atomic) BOOL gettingInformation;
@property (nonatomic, strong) NSNumber *radius;

///
/// Used only when the user tries to get deals without allowing location services
///
@property (nonatomic, strong) CLLocation *userHomeLocation;

@end

@implementation RNLocalContainerViewController

@synthesize radius = _radius;

- (void)viewDidLoad;
{
    [super viewDidLoad];

    self.gettingInformation = NO;
    self.radius = [self defaultRadius];
    
    [self setNavigationItemsEnabled:NO];
    
    if (_displayedViewController == nil) {
        self.listViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalViewController"];
        self.listViewController.delegate = self;
        _displayedViewController = self.listViewController;
    }
    
    self.manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    _manager.distanceFilter = kCLDistanceFilterNone;
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([_manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_manager requestWhenInUseAuthorization];
    } else {
        [_manager startUpdatingLocation];
    }
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];

    self.tabBarController.delegate = self;
    
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

- (void)setNavigationItemsEnabled:(BOOL)enabled;
{
    ///
    /// By default, they cannot navigate away, until the location has actually been received
    ///
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateDisabled];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateDisabled];
    
    self.navigationItem.rightBarButtonItem.enabled = enabled;
    self.navigationItem.leftBarButtonItem.enabled = enabled;
}

- (NSNumber *)defaultRadius;
{
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
    }
    ///
    /// Reset the deals every time the map is shown in case things
    /// have changed.
    ///
    self.mapViewController.deals = _deals;
    self.mapViewController.location = _manager.location == nil ? [_userHomeLocation coordinate] : [_manager.location coordinate];

    
    self.navigationItem.title = @"Map";
    
    [self transitionFromCurrentViewControllerToViewController:_mapViewController options:UIViewAnimationOptionTransitionFlipFromLeft];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector(listTapped:)];
    self.navigationItem.rightBarButtonItem = barButton;
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterTapped:)];
    self.navigationItem.leftBarButtonItem = filterButton;
}

- (IBAction)filterTapped:(id)sender {
    
    if (_filterViewController == nil) {
        self.filterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalFilterViewController"];
        self.filterViewController.delegate = self;
    }
    
    self.filterViewController.location = _manager.location == nil ? _userHomeLocation : _manager.location;
    
    self.navigationItem.title = @"Filter";
    
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
    self.navigationItem.title = @"Deals";
    
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
    
    if ([viewController isKindOfClass:[UINavigationController class]] &&
        ((UINavigationController *)viewController).viewControllers.count > 0 &&
        ((UINavigationController *)viewController).viewControllers[0] == self &&
        _displayedViewController != self.listViewController &&
        _isVisible ) {
        [self listTapped:nil];
    }
}

- (void)updateUserHomeLocation:(void (^)(void))callback;
{
    if (self.userHomeLocation == nil) {
        ///
        /// Use Address instead...
        ///
        RNUser *user = [[RNCart sharedCart] user];
        
        CLGeocoder *coder = [[CLGeocoder alloc] init];
        NSString *address = [NSString stringWithFormat:@"%@, %@ %@, %@, %@", user.address, user.apt != nil ? user.apt : @"", user.city, user.state, user.zipCode];
        [coder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark = [placemarks lastObject];
            self.userHomeLocation = [placemark location];
            if (callback) {
                callback();
            }
        }];
    } else {
        if (callback) {
            callback();
        }
    }
}

#pragma mark - RNLocalViewDelegate

- (void)refreshDataWithRadius:(NSNumber *)radius {
    
    if (radius == nil) {
        radius = _radius;
    } else {
        self.radius = radius;
    }
    
    self.gettingInformation = NO;
    [_manager startUpdatingLocation];
}

- (void)setRadius:(NSNumber *)radius;
{
    if (_radius != radius) {
        _radius = radius;
    }
}

- (NSNumber *)radius;
{
    return _radius;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;
{
    DLog(@"Status: %d", status);
    if (status == kCLAuthorizationStatusAuthorized ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways) {
        [_manager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
{
    DLog(@"Error: %@", error);
    
    [self updateUserHomeLocation:^{
        
        if (self.userHomeLocation == nil) {
            self.userHomeLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
        }

        [self locationManager:self.manager didUpdateLocations:@[self.userHomeLocation]];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
{
    CLLocation *location = [locations lastObject];
    
    if (!_gettingInformation) {
        self.gettingInformation = YES;
        [[RNWebService sharedClient] getDealsAtLocation:location query:@"" limit:50 offset:0 radius:_radius.doubleValue category:nil callback:^(RNResponse *response) {
            
            if ([response wasSuccessful]) {
                self.deals = response.result;
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:response.errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            
            if (self.displayedViewController == self.mapViewController) { //kind hackish :/
                self.mapViewController.location = location.coordinate;
            }
            [(RNLocalMapViewController *)self.displayedViewController setDeals:_deals]; //they all have this property
            self.gettingInformation = NO;
            
            [self setNavigationItemsEnabled:CLLocationCoordinate2DIsValid(location.coordinate)];
        }];
    }
    
    [manager stopUpdatingLocation];
}


@end

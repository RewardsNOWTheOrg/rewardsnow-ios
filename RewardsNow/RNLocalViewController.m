//
//  RNLocalViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNLocalViewController.h"
#import "RNLocalMapViewController.h"
#import "RNUser.h"
#import "RNCart.h"
#import "RNLocalDeal.h"
#import "RNWebService.h"
#import "RNLocalCell.h"
#import "UIImageView+AFNetworking.h"

@interface RNLocalViewController ()

@property (nonatomic, strong) RNLocalMapViewController *mapController;
@property (nonatomic, copy) NSArray *deals;
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL gettingInformation;

@end

@implementation RNLocalViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.topPointsLabel.text = [[RNCart sharedCart] getNamePoints];
    self.gettingInformation = NO;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshControl];
    [_refreshControl beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh:_refreshControl];
}

#pragma mark - UITableView Methods

- (void)refresh:(UIRefreshControl *)sender {
    
    self.manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    _manager.distanceFilter = kCLDistanceFilterNone;
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    [_manager startUpdatingLocation];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _deals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"LocalDealCell";
    RNLocalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    RNLocalDeal *deal = _deals[indexPath.row];
    
    cell.upperTitle.text = deal.businessName;
    cell.secondUpperLabel.text = deal.name;
    cell.textAreaLabel.text = deal.localDealDescription;
    cell.lowerLabel.text = [deal discountAsString];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:deal.imageURL];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [cell.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        DLog(@"Failed to get image!");
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Bar Button Methods

- (IBAction)filterTapped:(id)sender {
    
}

- (IBAction)mapTapped:(id)sender {
    
    if (self.mapController == nil) {
        self.mapController = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalMapViewController"];
    }
    
    [UIView transitionFromView:self.view
                        toView:self.mapController.view
                      duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
        
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStyleBordered target:self action:@selector(listTapped:)];
    }];
    

}

- (IBAction)listTapped:(id)sender {
    
    [UIView transitionFromView:self.mapController.view toView:self.view duration:0.8 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(mapTapped:)];
    }];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    
    if (!_gettingInformation) {
        self.gettingInformation = YES;
//        ?lat=43.19553545049059&limit=20&lon=-70.87328000848159&offset=0&q=&radius=15
//        CLLocation *locationHack = [[CLLocation alloc] initWithLatitude:43.19553545049059 longitude:-70.87328000848159];
        DLog(@"Location: %@", location);
        [[RNWebService sharedClient] getDeals:@"969" location:location query:@"" callback:^(id result) {
            if (result != nil) {
                self.deals = result;
                [self.tableView reloadData];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"The content could not be correctly fetched." delegate:nil cancelButtonTitle:@"Okay." otherButtonTitles:nil] show];
            }
            [self.refreshControl endRefreshing];
            self.gettingInformation = NO;
        }];
    }
    
    [manager stopUpdatingLocation];
}

@end

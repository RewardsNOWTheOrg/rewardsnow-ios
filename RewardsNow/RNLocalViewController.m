//
//  RNLocalViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNLocalViewController.h"
#import "RNLocalMapViewController.h"
#import "RNLocalDetailViewController.h"
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
    cell.dealImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [cell.dealImageView setImageWithURL:deal.imageURL];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"pushRNLocalDetailViewController"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        RNLocalDetailViewController *vc = segue.destinationViewController;
        vc.deal = _deals[indexPath.row];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    
    if (!_gettingInformation) {
        self.gettingInformation = YES;
        location = [[CLLocation alloc] initWithLatitude:43.19553545049059 longitude:-70.87328000848159];
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

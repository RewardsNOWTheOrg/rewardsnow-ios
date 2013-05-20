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

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation RNLocalViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.topPointsLabel.text = [[RNCart sharedCart] getNamePoints];
    
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
    [self.delegate refreshData];
}

- (void)setDeals:(NSArray *)deals {
    if (_deals != deals) {
        _deals = [deals copy];
    }
    
    [_refreshControl endRefreshing];
    [self.tableView reloadData];
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


@end

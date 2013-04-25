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

@interface RNRedeemViewController ()

@property (nonatomic, strong) NSArray *rewards;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation RNRedeemViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.rewards = [NSArray array];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshControl];
    [_refreshControl beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    RNUser *user = [[RNCart sharedCart] user];
    if (user == nil) {
        UINavigationController *auth = [self.storyboard instantiateViewControllerWithIdentifier:@"RNAuthNavigationController"];
        [self presentViewController:auth animated:NO completion:nil];
    }

    self.topPointsLabel.text = [NSString stringWithFormat:@"%@ Rewards: You have %@ points.", user.firstName, user.balance];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refresh:_refreshControl];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refresh:(UIRefreshControl *)sender {
    [[RNWebService sharedClient] getRewards:@"969" WithCallback:^(id result) {
        if (result) {
            self.rewards = result;
            [self.tableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"The content could not be correctly fetched." delegate:nil cancelButtonTitle:@"Okay." otherButtonTitles:nil] show];
        }
        [sender endRefreshing];
    }];
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
    
    cell.redeemTopLabel.text = [NSString stringWithFormat:@"$%d", (NSInteger)[self.rewards[indexPath.row] cashValue]];
    cell.redeemBottomLabel.text = [NSString stringWithFormat:@"%.0f Points", [self.rewards[indexPath.row] priceInPoints]];
    cell.redeemImage.contentMode = UIViewContentModeScaleAspectFit;
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if ([[segue identifier] isEqualToString:@"RedeemCellPush"]) {
        RNRedeemDetailViewController *detail = [segue destinationViewController];
        detail.info = self.rewards[indexPath.row];
    }
}

@end

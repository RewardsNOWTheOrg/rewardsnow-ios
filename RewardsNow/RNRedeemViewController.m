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

@interface RNRedeemViewController ()

@property (nonatomic, strong) NSArray *rewards;

@end

@implementation RNRedeemViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.rewards = [NSArray array];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    [refreshControl beginRefreshing];
    [self refresh:refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refresh:(UIRefreshControl *)sender {
    [[RNWebService sharedClient] getRewards:@"241" WithCallback:^(id result) {
        if (result) {
            self.rewards = result;
            [self.tableView reloadData];
            [sender endRefreshing];
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
    cell.redeemBottomLabel.text = [self.rewards[indexPath.row] catagoryDescription];
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

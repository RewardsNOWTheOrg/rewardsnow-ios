//
//  RNCartViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNCartViewController.h"
#import "RNCartConfirmationViewController.h"
#import "RNCart.h"
#import "RNUser.h"
#import "RNCartCell.h"
#import "RNRedeemObject.h"
#import "UIImageView+AFNetworking.h"


@interface RNCartViewController ()

@property (nonatomic, strong) RNCart *cart;

@end

@implementation RNCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cart = [RNCart sharedCart];
    self.topPointsLabel.text = [_cart getNamePoints];

    self.pointsAvailableLabel.text = [_cart.user stringBalance];
    self.pointsInCartLabel.text = [_cart stringTotal];
    self.pointsLeftLabel.text = [_cart stringPointsDifference];
    [self resizeView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.checkoutButton.enabled = _cart.items.count > 0;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.scrollView.contentOffset = CGPointZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

- (void)resizeView {
    CGFloat difference = self.innerViewHeight.constant - self.tableHeight.constant;
    self.tableHeight.constant = self.tableView.rowHeight * _cart.items.count;
    self.innerViewHeight.constant = self.tableHeight.constant + difference;
    self.scrollView.contentSize = CGSizeMake(320, self.innerViewHeight.constant);
    [self.view layoutIfNeeded];
}

- (IBAction)confirmTapped:(id)sender {
    
    ///
    /// Is possible to order?
    ///
    
    RNCartConfirmationViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RNCartAccountViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cart.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RNCartOverviewCell";

    RNCartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.upperLabel.text = [_cart.items[indexPath.row] descriptionName];
    cell.lowerLabel.text = [NSString stringWithFormat:@"%d points", (NSInteger)[_cart.items[indexPath.row] priceInPoints]];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[[_cart.items[indexPath.row] imageURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

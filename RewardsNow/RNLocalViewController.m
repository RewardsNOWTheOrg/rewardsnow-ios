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

@interface RNLocalViewController ()

@property (nonatomic, strong) RNLocalMapViewController *mapController;

@end

@implementation RNLocalViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    RNUser *user = [[RNCart sharedCart] user];
    self.topPointsLabel.text = [NSString stringWithFormat:@"%@ Rewards: You have %@ points.", user.firstName, user.balance];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - UITableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"LocalDealCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = @"Woot";
    
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
@end

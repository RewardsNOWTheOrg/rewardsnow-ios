//
//  RNAboutViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAboutViewController.h"
#import "RNAboutQAViewController.h"
#import "RNAboutRulesViewController.h"
#import "RNAboutEarningViewController.h"
#import "RNUser.h"
#import "RNCart.h"

@interface RNAboutViewController ()

@end

@implementation RNAboutViewController

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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"AboutCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = @[@"FAQ", @"Program Rules", @"Earning Points"][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc;
    switch (indexPath.row) {
        case 0:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RNAboutQAViewController"];
            break;
        case 1:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RNAboutRulesViewController"];
            break;
        default:
            vc = vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RNAboutEarningViewController"];
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];

}

@end

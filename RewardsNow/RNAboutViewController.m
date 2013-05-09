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
#import "RNConstants.h"

@interface RNAboutViewController ()

@property (nonatomic, copy) NSArray *cellNames;

@end

@implementation RNAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topPointsLabel.text = [[RNCart sharedCart] getNamePoints];
    self.cellNames = @[@"FAQ", @"Program Rules", @"Earning Points", @"Contact Us"];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor colorWithRed:C(235) green:C(235) blue:C(235) alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellNames.count;
    tableView.backgroundColor = [UIColor colorWithRed:C(235) green:C(235) blue:C(235) alpha:1.0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"AboutCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    UIColor *lightGrey = [UIColor colorWithRed:C(235) green:C(235) blue:C(235) alpha:1.0];
//    cell.contentView.backgroundColor = lightGrey;
//    cell.textLabel.backgroundColor = lightGrey;
    
    cell.textLabel.text = _cellNames[indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:C(235) green:C(235) blue:C(235) alpha:1.0];
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

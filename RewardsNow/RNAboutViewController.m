//
//  RNAboutViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAboutViewController.h"
#import "RNAboutDetailViewController.h"
#import "RNUser.h"
#import "RNCart.h"
#import "RNConstants.h"
#import "RNProgramInfo.h"
#import "RNWebService.h"

@interface RNAboutViewController ()

@property (nonatomic, copy) NSArray *cellNames;
@property (nonatomic, strong) RNProgramInfo *info;

@end

@implementation RNAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topPointsLabel.text = [[RNCart sharedCart] getNamePoints];
    self.cellNames = @[@"FAQ", @"Program Rules", @"Earning Points", @"Contact Us"];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor colorWithRed:C(235) green:C(235) blue:C(235) alpha:1.0];
    
    [[RNWebService sharedClient] getProgramInfo:@"969" callback:^(id result) {
        self.info = result;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"AboutCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = _cellNames[indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:C(235) green:C(235) blue:C(235) alpha:1.0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RNAboutDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RNAboutDetailViewController"];
    
    switch (indexPath.row) {
        case 0:
            vc.html = self.info.frequentlyAskedQuestions;
            break;
        case 1:
            vc.html = self.info.terms;
            break;
        case 2:
            vc.html = self.info.earningPoints;
            break;
        case 3:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RNAboutContactViewController"];
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];

}

@end

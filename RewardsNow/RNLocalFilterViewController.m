//
//  RNLocalFilterViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 5/20/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNLocalFilterViewController.h"
#import "RNWebService.h"
#import "MBProgressHUD.h"
#import "RNLocalViewController.h"
#import "RNCategory.h"
#import "RNResponse.h"

@interface RNLocalFilterViewController ()

@property (nonatomic, copy) NSArray *categories;

@end

@implementation RNLocalFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RNWebService sharedClient] getLocalCategoriesWithCallback:^(RNResponse *response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([response wasSuccessful]) {
            self.categories = response.result;
            [self.tableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:response.errorString delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        }
    }];

}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RNFilterCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [_categories[indexPath.row] name];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
#warning HardCoded Location Here
    
    [[RNWebService sharedClient] getDealsAtLocation:[[CLLocation alloc] initWithLatitude:43.19553545049059 longitude:-70.87328000848159]
                                              query:nil
                                              limit:20
                                             offset:0
                                             radius:15
                                           category:[_categories[indexPath.row] merchantCategory]
                                           callback:^(RNResponse *response) {
                                               
                                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                                               if ([response wasSuccessful]) {
                                                   RNLocalViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalViewController"];
                                                   vc.deals = response.result;
                                                   vc.isPushed = YES;
                                                   [self.navigationController pushViewController:vc animated:YES];
                                               } else {
                                                   [[[UIAlertView alloc] initWithTitle:@"Error" message:response.errorString delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
                                               }
                                           }];
}



@end

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

@interface RNLocalFilterViewController ()

@property (nonatomic, copy) NSArray *categories;

@end

@implementation RNLocalFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[RNWebService sharedClient] getLocalCategories:@"969" callback:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.categories = result;
        DLog(@"What: %@", _categories);
        [self.tableView reloadData];

    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
    
    [[RNWebService sharedClient] getDeals:@"969"
                                 location:_location
                                    query:nil
                                    limit:20
                                   offset:0
                                   radius:15.0
                                 category:[_categories[indexPath.row] merchantCategory]
                                 callback:^(id result) {
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     RNLocalViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalViewController"];
                                     vc.deals = result;
                                     vc.isPushed = YES;
                                     [self.navigationController pushViewController:vc animated:YES];
                                 }];
    
}



@end

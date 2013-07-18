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
@property (nonatomic, strong) RNLocalViewController *detailViewController;
@property (nonatomic, strong) NSNumber *selectedMerchantCategory;

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
            [[[UIAlertView alloc] initWithTitle:@"Error" message:response.errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    self.detailViewController = nil;
}

- (void)setDeals:(NSArray *)deals {
    if (_deals != deals) {
        _deals = [deals copy];
    }

    if ([self.navigationController.viewControllers.lastObject isKindOfClass:[RNLocalViewController class]]) {
        [self.navigationController.viewControllers.lastObject setDeals:deals];
    }
}

#pragma mark - RNLocalViewDelegate Methodsb

- (void)setRadius:(NSNumber *)radius;
{
    [self.delegate setRadius:radius];
}

- (NSNumber *)radius;
{
    return [self.delegate radius];
}

- (void)refreshDataWithRadius:(NSNumber *)radius;
{
    if (radius == nil) {
        radius = [self.delegate radius];
    } else {
        [self.delegate setRadius:radius];
    }

#warning hardcoded location
    [self getDealsForQuery:nil location:[[CLLocation alloc] initWithLatitude:43.19553545049059 longitude:-70.87328000848159] limit:20 offset:0 radius:radius.doubleValue category:_selectedMerchantCategory];
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
    self.selectedMerchantCategory = [_categories[indexPath.row] merchantCategory];
    
#warning fix radius, needs to be set around
    [self getDealsForQuery:nil location:[[CLLocation alloc] initWithLatitude:43.19553545049059 longitude:-70.87328000848159] limit:20 offset:0 radius:[[self.delegate radius] doubleValue] category:_selectedMerchantCategory];
}

- (void)getDealsForQuery:(NSString *)query location:(CLLocation *)location limit:(NSUInteger)limit offset:(NSUInteger)offset radius:(double)radius category:(NSNumber *)category;
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
#warning HardCoded Location Here
    
    [[RNWebService sharedClient] getDealsAtLocation:location
                                              query:query
                                              limit:limit
                                             offset:offset
                                             radius:radius
                                           category:category
                                           callback:^(RNResponse *response) {
                                               
                                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                                               
                                               if ([response wasSuccessful]) {
                                                   
                                                   if (self.detailViewController == nil) {
                                                       self.detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalViewController"];
                                                       self.detailViewController.deals = response.result;
                                                       self.detailViewController.delegate = self;
                                                       self.detailViewController.isPushed = YES;
                                                       [self.navigationController pushViewController:self.detailViewController animated:YES];
                                                   } else {
                                                       [self.detailViewController setDeals:response.result];
                                                   }
                                               } else {
                                                   [[[UIAlertView alloc] initWithTitle:@"Error" message:response.errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                               }
                                           }];
}



@end

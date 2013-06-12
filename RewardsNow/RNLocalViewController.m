//
//  RNLocalViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNLocalViewController.h"
#import "RNLocalMapViewController.h"
#import "RNLocalDetailViewController.h"
#import "RNUser.h"
#import "RNCart.h"
#import "RNLocalDeal.h"
#import "RNWebService.h"
#import "RNLocalCell.h"
#import "UIImageView+AFNetworking.h"
#import "RNPopoverViewController.h"

#define kSearchTable self.searchDisplayController.searchResultsTableView

@interface RNLocalViewController ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) WEPopoverController *popOver;
@property (nonatomic, strong) UISearchDisplayController * mySearchDisplayController;

@end

@implementation RNLocalViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchResults = [NSMutableArray array];
    self.topPointsLabel.text = [[RNCart sharedCart] getNamePoints];
    
    if (!_isPushed) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:_refreshControl];
        [_refreshControl beginRefreshing];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    // play with saerch bar
    UINavigationBar *topBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];

    UINavigationItem *item = [[UINavigationItem alloc] init];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.delegate = self;
    DLog(@"test1: %@", self.searchDisplayController);
    
    self.mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    _mySearchDisplayController.delegate = self;
    _mySearchDisplayController.searchResultsDataSource = self;
    _mySearchDisplayController.searchResultsDelegate = self;

    DLog(@"test2: %@", self.searchDisplayController);
    
    UIBarButtonItem *radius = [[UIBarButtonItem alloc] initWithTitle:@"15 mi" style:UIBarButtonItemStyleBordered target:self action:@selector(radiusBarButtonTapped:)];
    item.titleView = searchBar;
    item.rightBarButtonItem = radius;
    
    [topBar pushNavigationItem:item animated:NO];
    [self.tableView setTableHeaderView:topBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    DLog(@"What: %@", self.searchDisplayController);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh:_refreshControl];
}

#pragma mark - UITableView Methods

- (void)refresh:(UIRefreshControl *)sender {
    [self.delegate refreshData];
}

- (void)setDeals:(NSArray *)deals {
    if (_deals != deals) {
        _deals = [deals copy];
    }
    
    [_refreshControl endRefreshing];
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == kSearchTable) {
        return _searchResults.count;
    }
    return _deals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DLog(@"Tableview: %@", tableView);
    DLog(@"OThe: %@", self.searchDisplayController.searchResultsTableView);
    
    if (tableView == kSearchTable) {
        NSString *CellIdentifier = @"SearchResultCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        RNLocalDeal *deal = _searchResults[indexPath.row];
        cell.textLabel.text = deal.businessName;
        return cell;

    } else {
        NSString *CellIdentifier = @"LocalDealCell";
        RNLocalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        RNLocalDeal *deal = _deals[indexPath.row];
        
        cell.upperTitle.text = deal.businessName;
        cell.secondUpperLabel.text = deal.name;
        cell.textAreaLabel.text = deal.localDealDescription;
        cell.lowerLabel.text = [deal discountAsString];
        cell.dealImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [cell.dealImageView setImageWithURL:deal.imageURL];
        
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == kSearchTable) {
        RNLocalDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalDetailViewController"];
        vc.deal = _searchResults[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    } else {

    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"pushRNLocalDetailViewController"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        RNLocalDetailViewController *vc = segue.destinationViewController;
        vc.deal = _deals[indexPath.row];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterWithQuery:searchText];
}

- (void)filterWithQuery:(NSString *)query {
    [_searchResults removeAllObjects];
    for (RNLocalDeal *deal in _deals) {
        if ([deal doesMatchQuery:query]) {
            [_searchResults addObject:deal];
        }
    }
}

- (void)radiusBarButtonTapped:(UIBarButtonItem *)sender {
    
    if (_popOver == nil) {
        
//        CGRect frame = CGRectMake(0, 0, 70, 150);
//        UIView *backView = [[UIView alloc] initWithFrame:frame];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
//        label.backgroundColor = [UIColor greenColor];
//        label.text = @"derp";
//        [backView addSubview:label];
//        
//        UIViewController *viewCon = [[UIViewController alloc] init];
//        viewCon.view = backView;
//        viewCon.contentSizeForViewInPopover = frame.size;
        
        
        RNPopoverViewController *popup = [self.storyboard instantiateViewControllerWithIdentifier:@"RNPopoverViewController"];
        popup.contentSizeForViewInPopover = CGSizeMake(70, 4 * 44);
        //delegate
        
        self.popOver = [[WEPopoverController alloc] initWithContentViewController:popup];
        self.popOver.delegate = self;
    }
    
    if ([_popOver isPopoverVisible]) {
        
        [_popOver dismissPopoverAnimated:YES];
        [_popOver setDelegate:nil];
        self.popOver = nil;
    } else {
        
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        
        [_popOver presentPopoverFromRect:CGRectMake(screenBounds.size.width, 0, 50, 38)
                                  inView:self.view
                permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown
                                animated:YES];
    }
    
    
    

    
}

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {
    
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController {
    return YES;
}


@end

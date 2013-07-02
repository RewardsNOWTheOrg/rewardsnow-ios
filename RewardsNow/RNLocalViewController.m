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
#import "RNConstants.h"
#import "RNBranding.h"

#define kSearchTable self.searchDisplayController.searchResultsTableView

@interface RNLocalViewController ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) WEPopoverController *popOver;
@property (nonatomic, strong) UISearchDisplayController * mySearchDisplayController;
@property (nonatomic, strong) UINavigationItem *lowerNavigationBar;
@property (nonatomic, strong) UINavigationBar *topBar;

@end

@implementation RNLocalViewController

- (void)brand {
    [super brand];
}


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
        [self addTableFooter];
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    // play with Search bar
    self.topBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];

    self.lowerNavigationBar = [[UINavigationItem alloc] init];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.delegate = self;
    
    self.mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    _mySearchDisplayController.delegate = self;
    _mySearchDisplayController.searchResultsDataSource = self;
    _mySearchDisplayController.searchResultsDelegate = self;
    
    UIBarButtonItem *radius = [[UIBarButtonItem alloc] initWithTitle:@"15 mi" style:UIBarButtonItemStyleBordered target:self action:@selector(radiusBarButtonTapped:)];
    _lowerNavigationBar.titleView = searchBar;
    _lowerNavigationBar.rightBarButtonItem = radius;
    
    [_topBar pushNavigationItem:_lowerNavigationBar animated:NO];
    [self.tableView setTableHeaderView:_topBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hidePopover];
}

#pragma mark - UITableView Methods

- (void)refresh:(UIRefreshControl *)sender {
    [self.delegate refreshDataWithRadius:nil];
}

- (void)setDeals:(NSArray *)deals {
    if (_deals != deals) {
        _deals = [deals copy];
    }
    
    [self addTableFooter];
    
    [_refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)addTableFooter {
    
    if (_deals.count == 0) {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        footer.backgroundColor = self.branding.commonBackgroundColor;
        
        UILabel *noResponse = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
        noResponse.text = @"Sorry, no deals are available in this area.";
        noResponse.font = [UIFont fontWithName:@"Arial" size:15];
        noResponse.backgroundColor = self.branding.commonBackgroundColor;
        [footer addSubview:noResponse];
        
        self.tableView.tableFooterView = footer;
    } else {
        self.tableView.tableFooterView = nil;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == kSearchTable) {
        return _searchResults.count;
    }
    return _deals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == kSearchTable) {
        NSString *CellIdentifier = @"SearchResultCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        RNLocalDeal *deal = _searchResults[indexPath.row];
        cell.textLabel.text = deal.businessName;
        cell.detailTextLabel.text = deal.name;
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
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hidePopover];
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
    
    if (self.searchDisplayController.isActive) {
        return;
    }
    
    if (_popOver == nil) {
        
        RNPopoverViewController *popup = [self.storyboard instantiateViewControllerWithIdentifier:@"RNPopoverViewController"];
        popup.contentSizeForViewInPopover = CGSizeMake(70, 4 * 44);
        popup.delegate = self;
        
        self.popOver = [[WEPopoverController alloc] initWithContentViewController:popup];
        self.popOver.delegate = self;
    }
    
    if ([_popOver isPopoverVisible]) {
        [self hidePopover];
    } else {
        
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        
        CGPoint center = [_topBar convertPoint:_topBar.center toView:nil];

        center.x = screenBounds.size.width;
        
        [_popOver presentPopoverFromRect:CGRectMake(center.x, center.y - 90, 50, 38)
                                  inView:self.view
                permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown
                                animated:YES];
    }
}

- (void)hidePopover {
    if ([_popOver isPopoverVisible]) {
        
        [_popOver dismissPopoverAnimated:YES];
        [_popOver setDelegate:nil];
        self.popOver = nil;
    }
}

- (void)popoverDidFinishWithIndexPathSelected:(NSIndexPath *)indexPath {
    
    NSString *title = [NSString stringWithFormat:@"%@ mi", [RNConstants radii][indexPath.row]];
    self.lowerNavigationBar.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(radiusBarButtonTapped:)];
    [self hidePopover];
    
    [self.delegate refreshDataWithRadius:[RNConstants radii][indexPath.row]];
    [_refreshControl beginRefreshing];
}

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {
    
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController {
    return YES;
}


@end

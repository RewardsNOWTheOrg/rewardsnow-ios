//
//  RNLocalMapViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNLocalMapViewController.h"
#import "RNAnnotation.h"
#import "RNLocalDeal.h"
#import "RNConstants.h"
#import "RNLocalDetailViewController.h"

@interface RNLocalMapViewController ()

@property (nonatomic) BOOL isFirstLoad;
@property (nonatomic, strong) NSMutableArray *searchedDeals;
@property (nonatomic, strong) NSMutableArray *annotations;

@end

@implementation RNLocalMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstLoad = YES;
    self.searchedDeals = [NSMutableArray array];
    self.annotations = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - MKMapView Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[RNAnnotation class]]) {
        
        // try to dequeue an existing pin view first
        static NSString *AddresssAnnotationIdentifier = @"RNMapViewAnnotation";
        
        MKPinAnnotationView *pinView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:AddresssAnnotationIdentifier];
        if (!pinView) {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AddresssAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorRed;
            customPinView.animatesDrop = NO;
            customPinView.canShowCallout = YES;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [button addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = button;
            return customPinView;
        } else {
            pinView.annotation = annotation;
        }
        
        return pinView;
    }
    
    return nil;
}

- (MKCoordinateRegion)calculateRegionForDeals:(NSArray *)deals {
    
    if (deals.count == 0) {
        return MKCoordinateRegionMake(_location, MKCoordinateSpanMake(MapSpanSize, MapSpanSize));
    }
    
    double minLat = INFINITY;
    double minLong = INFINITY;
    double maxLat = -INFINITY;
    double maxLong = -INFINITY;
    double latitude = 0;
    double longitude = 0;
    
    for (NSInteger i = 0; i < deals.count; i++) {
        RNLocalDeal *loc = deals[i];
        
        latitude += loc.location.coordinate.latitude;
        longitude += loc.location.coordinate.longitude;
        
        if (loc.location.coordinate.latitude < minLat) {
            minLat = loc.location.coordinate.latitude;
        }
        
        if (loc.location.coordinate.latitude > maxLat) {
            maxLat = loc.location.coordinate.latitude;
        }
        
        if (loc.location.coordinate.longitude < minLong) {
            minLong = loc.location.coordinate.longitude;
        }
        
        if (loc.location.coordinate.longitude > maxLong) {
            maxLong = loc.location.coordinate.longitude;
        }
    }
    
    latitude /= deals.count;
    longitude /= deals.count;
    
    double spanLat = (maxLat - minLat) * 1.5 < MapSpanSize ? MapSpanSize : (maxLat - minLat) * 1.5;
    double spanLong = (maxLong - minLong) * 1.5 < MapSpanSize ? MapSpanSize : (maxLong - minLong) * 1.5;
    
    return MKCoordinateRegionMake(CLLocationCoordinate2DMake(latitude, longitude), MKCoordinateSpanMake( spanLat, spanLong));
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
    if (_isFirstLoad) {
        self.isFirstLoad = NO;
        [self.mapView setRegion:[self calculateRegionForDeals:_deals] animated:YES];
    }

    
    for (NSInteger i = 0; i < _deals.count; i++) {
        RNLocalDeal *deal = _deals[i];
        double delayInSeconds = i * (1.0 / _deals.count);
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self placeAnnotationAtLocation:deal.coordinate2D forDeal:deal];
        });
    }
}

- (void)placeAnnotationAtLocation:(CLLocationCoordinate2D)location forDeal:(RNLocalDeal *)deal {
    
    RNAnnotation *annotation = [[RNAnnotation alloc] init];
    annotation.coordinate = location;
    annotation.title = deal.businessName;
    annotation.subtitle = deal.address;
    annotation.deal = deal;
    
    [self.annotations addObject:annotation];
    [self.mapView addAnnotation:annotation];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ( [view isKindOfClass:[MKPinAnnotationView class]] ) {
        MKPinAnnotationView *theView = (MKPinAnnotationView *)view;
        theView.pinColor = MKPinAnnotationColorGreen;
    }
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ( [view isKindOfClass:[MKPinAnnotationView class]] ) {
        MKPinAnnotationView *theView = (MKPinAnnotationView *)view;
        theView.pinColor = MKPinAnnotationColorRed;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    RNLocalDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalDetailViewController"];
    controller.deal = ((RNAnnotation *)view.annotation).deal;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UISearchBar Table

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    DLog(@"Search: %@", searchText);
    
    [self filterWithQuery:searchText];
}

- (void)filterWithQuery:(NSString *)query {
    [_searchedDeals removeAllObjects];
    for (RNLocalDeal *deal in _deals) {
        if ([deal doesMatchQuery:query]) {
            [_searchedDeals addObject:deal];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchedDeals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SearchDisplayCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [_searchedDeals[indexPath.row] businessName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchDisplayController setActive:NO animated:YES];
    
    RNLocalDeal *deal = _searchedDeals[indexPath.row];
    NSUInteger index = [_deals indexOfObject:deal];
    [self.mapView selectAnnotation:_annotations[index] animated:YES];
    [self.mapView setRegion:[self calculateRegionForDeals:@[deal]] animated:YES];
}

@end

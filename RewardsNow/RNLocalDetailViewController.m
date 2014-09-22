//
//  RNLocalDetailViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNLocalDetailViewController.h"
#import "RNLocalAdditionalViewController.h"
#import "RNLocalDeal.h"
#import "UIImageView+AFNetworking.h"
#import "RNAnnotation.h"
#import "RNConstants.h"
#import "RNBranding.h"
#import <QuartzCore/QuartzCore.h>
#import <AddressBookUI/AddressBookUI.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface RNLocalDetailViewController ()

@property (nonatomic) BOOL hasFinishedLoadingMap;
@property (nonatomic, copy) NSArray *cellRows;

@end

@implementation RNLocalDetailViewController

- (void)brand {
    [super brand];
    self.lowerInnerView.backgroundColor = self.branding.backgroundColor;
    self.lowerUpperLabel.backgroundColor = self.branding.pointsColor;
    
    self.tableView.backgroundColor = self.branding.backgroundColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasFinishedLoadingMap = NO;
    
    self.upperTopLabel.text = _deal.businessName;
    self.upperMiddleLabel.text = [NSString stringWithFormat:@"%@, %@", _deal.city, _deal.state];
    self.upperLowerLabel.text = _deal.name;
    [self.topImageView setImageWithURL:_deal.imageURL];
    
    self.lowerUpperLabel.text = _deal.localDealDescription;
    _lowerUpperLabel.layer.cornerRadius = 4.0;
    
    _mapView.layer.cornerRadius = 4.0;
    _mapView.layer.masksToBounds = YES;
    _mapView.scrollEnabled = NO;
    
    
    NSMutableArray *rows = [NSMutableArray array];
    
    if (_deal.website != nil && _deal.website.absoluteString.length > 0) {
        [rows addObject:@{@"title": [NSString stringWithFormat:@"Visit: %@", _deal.website.absoluteString], @"action" : ^{
            if (![[UIApplication sharedApplication] openURL:_deal.website]) {NSLog(@"Failed to open url.");}
            }
         }];
    }
    
    if (_deal.phoneNumber != nil) {
        [rows addObject:@{@"title": [NSString stringWithFormat:@"Call: %@", _deal.phoneNumber], @"action" : ^{
            if (![[UIApplication sharedApplication] openURL:_deal.phoneURL]) {NSLog(@"Failed to make call");}
            }   
         }];
    }
    
    if (_deal.additionalInformation.length > 0) {
        [rows addObject:@{@"title": @"Additional Information", @"action" : ^{
            RNLocalAdditionalViewController *more = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalAdditionalViewController"];
            more.deal = _deal;
            [self.navigationController pushViewController:more animated:YES];
        }
    }];
    }
    
    self.cellRows = rows;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _descriptionHeight.constant = 50;
    [self updateViewConstraints];
    [self.view layoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _lowerUpperLabel.frame = CGRectMake(10, 6, 295, 20);
    _descriptionHeight.constant = _lowerUpperLabel.contentSize.height;
    _tableViewHeight.constant = _cellRows.count * (_tableView.rowHeight + 6);
    self.lowerInnerViewHeight.constant = _descriptionHeight.constant + 180 + (_cellRows.count * 44);
    [self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.scrollView setScrollEnabled:YES];
    CGSize size = _scrollView.contentSize;
    size.height = _lowerInnerView.frame.origin.y + _lowerInnerView.frame.size.height;
    [self.scrollView setContentSize:size];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self updateMapView];
    }

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.scrollView.contentOffset = CGPointZero;
}

- (IBAction)directionsTapped:(id)sender {
    [_deal openInMaps];
}

#pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellRows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"LocalDealDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = _cellRows[indexPath.row][@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    void (^action)(void) = _cellRows[indexPath.row][@"action"];
    action();
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[RNAnnotation class]]) {
        
        // try to dequeue an existing pin view first
        static NSString *AddresssAnnotationIdentifier = @"RNAnnotationIdentifier";
        
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [((RNAnnotation *)view.annotation).deal openInMaps];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    [self updateMapView];
}

- (void)updateMapView;
{
    if (!self.hasFinishedLoadingMap) {
        [self.mapView setRegion:MKCoordinateRegionMake(_deal.coordinate2D, MKCoordinateSpanMake(MapSpanSize, MapSpanSize)) animated:NO];
        [self placeAnnotationAtLocation:_deal.coordinate2D];
        self.hasFinishedLoadingMap = YES;
    }
}

- (void)placeAnnotationAtLocation:(CLLocationCoordinate2D)location {
    
    RNAnnotation *annotation = [[RNAnnotation alloc] init];
    annotation.coordinate = location;
    annotation.title = _deal.businessName;
    annotation.subtitle = _deal.address;
    annotation.deal = _deal;
    
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];

}


@end

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
@property (nonatomic, strong) RNBranding *branding;

@end

@implementation RNLocalDetailViewController

- (void)brand;
{
    self.lowerInnerView.backgroundColor = self.branding.backgroundColor;
    self.lowerUpperLabel.backgroundColor = self.branding.pointsColor;
    self.tableView.backgroundColor = self.branding.backgroundColor;
    
    self.view.backgroundColor = _branding.commonBackgroundColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.tabBarController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: _branding.tabBarTextColor}
                                                    forState:UIControlStateNormal];
    [self.tabBarController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: _branding.tabBarTextColor}
                                                    forState:UIControlStateNormal];
    
    if ([self respondsToSelector:@selector(innerView)]) {
        [[self performSelector:@selector(innerView)] setBackgroundColor:_branding.commonBackgroundColor];
    }
    
    if ([self respondsToSelector:@selector(topPointsLabel)]) {
        [[self performSelector:@selector(topPointsLabel)] setBackgroundColor:_branding.pointsColor];
        //        [[self performSelector:@selector(topPointsLabel)] setTextColor:_branding.pointsColor];
    }

}

- (void)viewDidLoad;
{
    if ( (self.branding = [RNBranding sharedBranding]) ) {
        [self brand];
    }
    
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

- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    CGRect newFrame = self.lowerInnerView.frame;
    newFrame.size.height = self.upperViewHeight.constant + _lowerUpperLabel.frame.size.height + _mapHeight.constant + 30;
    if (self.lowerInnerView.frame.size.height != newFrame.size.height) {
        self.lowerInnerView.frame = newFrame;
        [self.tableView setTableHeaderView:self.lowerInnerView];
    }
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    [self updateMapView];
}

- (IBAction)directionsTapped:(id)sender;
{
    [_deal openInMaps];
}

#pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _cellRows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NSString *CellIdentifier = @"LocalDealDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = _cellRows[indexPath.row][@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    void (^action)(void) = _cellRows[indexPath.row][@"action"];
    if (action) {
        action();
    }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation;
{
    
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
{
    [((RNAnnotation *)view.annotation).deal openInMaps];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView;
{
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

- (void)placeAnnotationAtLocation:(CLLocationCoordinate2D)location;
{
    RNAnnotation *annotation = [[RNAnnotation alloc] init];
    annotation.coordinate = location;
    annotation.title = _deal.businessName;
    annotation.subtitle = _deal.address;
    annotation.deal = _deal;
    
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];

}


@end

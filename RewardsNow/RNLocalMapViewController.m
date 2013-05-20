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

@interface RNLocalMapViewController ()

@end

@implementation RNLocalMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Object Methods

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
            return customPinView;
        } else {
            pinView.annotation = annotation;
        }
        
        return pinView;
    }
    
    return nil;
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
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

@end

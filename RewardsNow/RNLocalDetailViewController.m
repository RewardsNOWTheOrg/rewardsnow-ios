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
#import "CMLabel.h"
#import "RNConstants.h"
#import "NSString+Additions.h"
#import <QuartzCore/QuartzCore.h>
#import <AddressBookUI/AddressBookUI.h>

@interface RNLocalDetailViewController ()

@property (nonatomic) BOOL hasFinishedLoadingMap;
@property (nonatomic, copy) NSArray *cellRows;

@end

@implementation RNLocalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasFinishedLoadingMap = NO;
    
    self.upperTopLabel.text = _deal.businessName;
    self.upperMiddleLabel.text = _deal.address;
    self.upperLowerLabel.text = _deal.name;
    [self.topImageView setImageWithURL:_deal.imageURL];
    
    self.lowerUpperLabel.text = _deal.localDealDescription;
    self.lowerUpperLabel.layer.cornerRadius = 4.0;
    self.lowerUpperLabel.textInsets = UIEdgeInsetsMake(2, 4, 2, 4);
    
    _mapView.layer.cornerRadius = 4.0;
    _mapView.layer.masksToBounds = YES;
    
    self.mapAddressLabel.text = ABCreateStringWithAddressDictionary(_deal.addressDictionary, NO);
    
    
    NSMutableArray *rows = [NSMutableArray array];
    
    if (_deal.website != nil && [_deal.website.absoluteString isNotEmpty]) {
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
    
    [rows addObject:@{@"title": @"Additional Information", @"action" : ^{
        RNLocalAdditionalViewController *more = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalAdditionalViewController"];
        more.deal = _deal;
        [self.navigationController pushViewController:more animated:YES];
    }
     }];
    
    self.cellRows = rows;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
//    
//    UIGraphicsBeginImageContext(self.lowerUpperLabel.frame.size);
//    [[UIImage imageNamed:@"grey-button.png"] drawInRect:self.lowerUpperLabel.bounds];
//    UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    self.lowerUpperLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey-button.png"] ];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.scrollView setScrollEnabled:YES];
    CGSize size = _scrollView.contentSize;
    size.height = _lowerInnerView.frame.origin.y + _lowerInnerView.frame.size.height;
    [self.scrollView setContentSize:size];
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
            return customPinView;
        } else {
            pinView.annotation = annotation;
        }
        
        return pinView;
    }
    
    return nil;
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
    if (!_hasFinishedLoadingMap) {
        [self.mapView setRegion:MKCoordinateRegionMake(_deal.coordinate2D, MKCoordinateSpanMake(MapSpanSize, MapSpanSize)) animated:NO];
        [self placeAnnotationAtLocation:_deal.coordinate2D];
    }
    
    self.hasFinishedLoadingMap = YES;
}

- (void)placeAnnotationAtLocation:(CLLocationCoordinate2D)location {
    
    RNAnnotation *annotation = [[RNAnnotation alloc] init];
    annotation.coordinate = location;
    annotation.title = _deal.businessName;
    annotation.subtitle = _deal.address;
    
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];

}


@end

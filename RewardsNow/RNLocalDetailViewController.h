//
//  RNLocalDetailViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class RNLocalDeal, CMLabel;

@interface RNLocalDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (nonatomic, strong) RNLocalDeal *deal;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *upperTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperMiddleLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperLowerLabel;
@property (weak, nonatomic) IBOutlet CMLabel *lowerUpperLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet CMLabel *mapAddressLabel;
@property (weak, nonatomic) IBOutlet UIView *lowerInnerView;

- (IBAction)directionsTapped:(id)sender;

@end

//
//  RNAnnotation.h
//  RewardsNow
//
//  Created by Ethan Mick on 5/14/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class RNLocalDeal;

@interface RNAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) RNLocalDeal *deal;

@end

//
//  RNLocalDeal.h
//  RewardsNow
//
//  Created by Ethan Mick on 5/1/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNObject.h"
#import <CoreLocation/CoreLocation.h>

@interface RNLocalDeal : RNObject

@property (nonatomic, strong) NSDate *activeFrom;
@property (nonatomic, strong) NSDate *activeTo;
@property (nonatomic, copy) NSString *additionalInformation;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *businessName;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *localDealDescription;
@property (nonatomic, copy) NSString *discountString;
@property (nonatomic, strong) NSNumber *discountValue;
@property (nonatomic, strong) NSNumber *offerID;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSURL *website;
@property (nonatomic, copy) NSString *zipCode;

- (NSString *)discountAsString;
- (CLLocationCoordinate2D)coordinate2D;
- (NSDictionary *)addressDictionary;
- (NSURL *)phoneURL;
- (void)openInMaps;
- (BOOL)doesMatchQuery:(NSString *)query;

@end

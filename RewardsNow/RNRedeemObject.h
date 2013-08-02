//
//  RNRedeemObject.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNObject.h"

@interface RNRedeemObject : RNObject

@property (nonatomic) double cashValue;
@property (nonatomic, copy) NSString *catagoryDescription;
@property (nonatomic, copy) NSString *catalogCode;
@property (nonatomic, strong) NSNumber *catalogID;
@property (nonatomic, strong) NSNumber *categoryID;
@property (nonatomic, copy) NSString *descriptionName;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic) double  priceInPoints;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *terms;

- (NSString *)stringPriceInPoints;
- (NSString *)catalogIDString;

@end

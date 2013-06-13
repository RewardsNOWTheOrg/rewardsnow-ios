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
@property (nonatomic) NSInteger catalogID;
@property (nonatomic) NSInteger categoryID;
@property (nonatomic, copy) NSString *objectDescription;
@property (nonatomic, copy) NSString *descriptionName;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic) double  priceInPoints;
@property (nonatomic, strong) UIImage *image;

- (NSString *)stringPriceInPoints;

@end

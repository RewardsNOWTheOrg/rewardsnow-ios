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
@property (nonatomic, strong) NSString *catagoryDescription;
@property (nonatomic, strong) NSString *catalogCode;
@property (nonatomic) NSInteger catalogID;
@property (nonatomic) NSInteger categoryID;
@property (nonatomic, strong) NSString *objectDescription;
@property (nonatomic, strong) NSString *descriptionName;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic) double  priceInPoints;
@property (nonatomic, strong) UIImage *image;

@end

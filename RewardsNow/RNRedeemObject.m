//
//  RNRedeemObject.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNRedeemObject.h"

NSString *const CashValueKey = @"CashValue";
NSString *const CatagoryDescKey = @"CatagoryDesc";
NSString *const CatalogCodeKey = @"CatalogCodeKey";
NSString *const CatalogIdKey = @"CatalogId";
NSString *const CategoryIdKey = @"CategoryId";
NSString *const DescriptionKey = @"Description";
NSString *const DescriptionNameKey = @"DescriptionName";
NSString *const ImageKey = @"Image";
NSString *const PriceInPointsKey = @"PriceInPoints";


@implementation RNRedeemObject


#pragma mark - Mantle

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"cashValue": @"CashValue",
             @"catagoryDescription" : @"CatagoryDesc",
             @"catalogCode" : @"CatalogCodeKey",
             @"catalogID" : @"CatalogId",
             @"categoryID" : @"CategoryId",
             @"description" : @"Description",
             @"descriptionName" : @"DescriptionName",
             @"imageURL" : @"Image",
             @"priceInPoints" : @"PriceInPoints"
             };
}

@end

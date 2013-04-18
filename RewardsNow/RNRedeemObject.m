//
//  RNRedeemObject.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNRedeemObject.h"

@implementation RNRedeemObject


#pragma mark - Mantle

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSMutableDictionary *fields = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [fields setValue:@"CashValue" forKey:@"cashValue"];
    [fields setValue:@"CatagoryDesc" forKey:@"catagoryDescription"];
    [fields setValue:@"CatalogCodeKey" forKey:@"catalogCode"];
    [fields setValue:@"CatalogId" forKey:@"catalogID"];
    [fields setValue:@"CategoryId" forKey:@"categoryID"];
    [fields setValue:@"Description" forKey:@"objectDescription"];
    [fields setValue:@"DescriptionName" forKey:@"descriptionName"];
    [fields setValue:@"Image" forKey:@"imageURL"];
    [fields setValue:@"PriceInPoints" forKey:@"priceInPoints"];
    return fields;
}

@end

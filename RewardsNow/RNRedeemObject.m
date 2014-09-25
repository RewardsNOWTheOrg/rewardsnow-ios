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
    [fields setValue:@"CatalogCode" forKey:@"catalogCode"];
    [fields setValue:@"CatalogId" forKey:@"catalogID"];
    [fields setValue:@"CategoryId" forKey:@"categoryID"];
    [fields setValue:@"DescriptionName" forKey:@"descriptionName"];
    [fields setValue:@"Image" forKey:@"imageURL"];
    [fields setValue:@"PriceInPoints" forKey:@"priceInPoints"];
    [fields setValue:@"Terms" forKey:@"terms"];
    return fields;
}

- (NSString *)stringPriceInPoints {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:[[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
    return [formatter stringFromNumber:@(_priceInPoints)];
}

- (NSString *)catalogIDString;
{
    return [NSString stringWithFormat:@"%ld", self.catalogID.longValue];
}

@end

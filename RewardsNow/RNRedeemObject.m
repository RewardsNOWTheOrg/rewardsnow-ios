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

- (id)initWithDictionary:(NSDictionary *)dict {
    
    if ( (self = [super initWithDictionary:dict]) ) {
        
        @try {
            self.cashValue = [dict[CashValueKey] doubleValue];
            self.catagoryDescription = dict[CatagoryDescKey];
            self.catalogCode = dict[CatalogCodeKey];
            self.catalogID = [dict[CatalogIdKey] integerValue];
            self.categoryID = [dict[CategoryIdKey] integerValue];
            self.description = dict[DescriptionKey];
            self.descriptionName = dict[DescriptionNameKey];
            self.imageURL = dict[ImageKey];
            self.priceInPoints = [dict[PriceInPointsKey] doubleValue];
        }
        @catch (NSException *exception) {
            DLog(@"Error Parsing Object! %@", exception);
        }
    }
    return self;
}

@end

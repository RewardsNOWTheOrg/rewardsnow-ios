//
//  RNGiftCard.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/18/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNGiftCard.h"

@implementation RNGiftCard

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"cardDescription": @"Description",
             @"cardNumber" : @"GiftCardNumber",
             };
}

+ (NSValueTransformer *)stateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [NSNumber numberWithInteger:[str integerValue]];
    } reverseBlock:^(NSNumber *state) {
        return state;
    }];
}

@end

//
//  RNUser.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/18/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNUser.h"
#import "RNGiftCard.h"

@implementation RNUser


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"firstName": @"Info.FirstName",
             @"fullName" : @"Info.FullName",
             @"email" : @"Info.Email",
             @"balance" : @"Info.AvailableBalance",
             @"giftCards" : @"GiftCards"
             };
}

+ (NSValueTransformer *)giftCardsJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSArray *cards) {
        return [RNGiftCard objectsFromJSON:cards];
    }];
}

@end

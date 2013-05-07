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
    
    NSMutableDictionary *fields = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [fields setValue:@"Info.FirstName" forKey:@"firstName"];
    [fields setValue:@"Info.FullName" forKey:@"fullName"];
    [fields setValue:@"Info.Email" forKey:@"email"];
    [fields setValue:@"Info.AvailableBalance" forKey:@"balance"];
    [fields setValue:@"GiftCards" forKey:@"giftCards"];
    return fields;
}

+ (NSValueTransformer *)giftCardsJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSArray *cards) {
        return [RNGiftCard objectsFromJSON:cards];
    }];
}

- (NSString *)stringBalance {
    return [self formattedStringFromNumber:_balance];
}

@end

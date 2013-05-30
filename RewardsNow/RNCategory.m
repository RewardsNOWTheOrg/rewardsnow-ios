//
//  RNCategory.m
//  RewardsNow
//
//  Created by Ethan Mick on 5/28/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNCategory.h"

@implementation RNCategory

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSMutableDictionary *fields = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [fields setValue:@"IdMerchantCategory" forKey:@"merchantCategory"];
    [fields setValue:@"Name" forKey:@"name"];
    return fields;
}


@end

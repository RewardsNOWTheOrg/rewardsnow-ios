//
//  RNAccountStatement.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/12/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAccountStatement.h"

@implementation RNAccountStatement

#pragma mark - Mantle

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSMutableDictionary *fields = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [fields setValue:@"BeginningPointsBalance" forKey:@"pointsBeginning"];
    [fields setValue:@"EndingPointsBalance" forKey:@"pointsEnd"];
    return fields;
}


@end

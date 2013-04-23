//
//  RNPointChange.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/12/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNPointChange.h"

@implementation RNPointChange

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSMutableDictionary *fields = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [fields setValue:@"Points" forKey:@"points"];
    [fields setValue:@"StatementTypeName" forKey:@"statementType"];
    return fields;
}

@end

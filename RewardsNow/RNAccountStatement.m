//
//  RNAccountStatement.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/12/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAccountStatement.h"
#import "RNTransaction.h"
#import "RNPointChange.h"


@implementation RNAccountStatement

#pragma mark - Mantle

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSMutableDictionary *fields = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [fields setValue:@"BeginningPointsBalance.Points" forKey:@"pointsBeginning"];
    [fields setValue:@"EndingPointsBalance.Points" forKey:@"pointsEnd"];
    [fields setValue:@"HistoryDetails" forKey:@"history"];
    [fields setValue:@"PointsDecreased" forKey:@"pointsDecrease"];
    [fields setValue:@"PointsIncreased" forKey:@"pointsIncrease"];
    return fields;
}

+ (NSValueTransformer *)pointsIncreaseJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:RNPointChange.class];
}

+ (NSValueTransformer *)pointsDecreaseJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:RNPointChange.class];
}

+ (NSValueTransformer *)historyJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:RNTransaction.class];
}


@end

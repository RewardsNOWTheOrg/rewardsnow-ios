//
//  RNTransaction.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/12/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNTransaction.h"

@implementation RNTransaction

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSMutableDictionary *fields = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [fields setValue:@"Points" forKey:@"points"];
    [fields setValue:@"MerchantName" forKey:@"merchantName"];
    [fields setValue:@"HistDate" forKey:@"transactionDate"];
    [fields setValue:@"Description" forKey:@"transactionDescription"];
    [fields setValue:@"AcctId" forKey:@"accountID"];
    return fields;
}

@end

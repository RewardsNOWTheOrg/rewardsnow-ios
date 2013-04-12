//
//  RNTransaction.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/12/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNTransaction.h"

/*
 "AcctId": "1234D00000109901",
 "Description": "Debit Pin Purchase                      ",
 "HistDate": "/Date(1338440400000-0500)/",
 "HistKey": 1,
 "MerchantName": "",
 "Points": 9
 */

@implementation RNTransaction

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    if ( (self = [super initWithDictionary:dict]) ) {
        self.accountID = dict[@"AcctId"];
        self.description = dict[@"Description"];
        self.transactionDate = dict[@"HistDate"];
        self.MerchantName = dict[@"MerchantName"];
        self.points = dict[@"Points"];
    }
    return self;
}

@end

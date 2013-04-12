//
//  RNTransaction.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/12/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNObject.h"

/*
 "AcctId": "1234D00000109901",
 "Description": "Debit Pin Purchase                      ",
 "HistDate": "/Date(1338440400000-0500)/",
 "HistKey": 1,
 "MerchantName": "",
 "Points": 9
 */

@interface RNTransaction : RNObject

@property (nonatomic, strong) NSString *accountID;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSDate *transactionDate;
@property (nonatomic, strong) NSString *MerchantName;
@property (nonatomic, strong) NSNumber *points;

@end

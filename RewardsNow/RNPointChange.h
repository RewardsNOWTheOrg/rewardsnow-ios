//
//  RNPointChange.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/12/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNObject.h"

/*
 "Points": 0,
 "StatementTypeId": 6,
 "StatementTypeName": "Other Adjustments",
 */

@interface RNPointChange : RNObject

@property (nonatomic, strong) NSNumber *points;
@property (nonatomic, strong) NSString *statementType;

@end

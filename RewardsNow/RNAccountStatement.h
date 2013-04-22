//
//  RNAccountStatement.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/12/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNObject.h"

@interface RNAccountStatement : RNObject

@property (nonatomic, strong) NSDate *dateStart;
@property (nonatomic, strong) NSDate *dateEnd;
@property (nonatomic, strong) NSNumber *pointsBeginning;
@property (nonatomic, strong) NSNumber *pointsEnd;

@property (nonatomic, copy) NSArray *pointsIncrease;
@property (nonatomic, copy) NSArray *pointsDecrease;
@property (nonatomic, copy) NSArray *history;

@end

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
@property (nonatomic, strong) NSNumber *points;

@property (nonatomic, copy) NSArray *pointsIncrease;
@property (nonatomic, copy) NSArray *pointsDecrease;
@property (nonatomic, copy) NSArray *history;

- (void)setPointsIncreaseFromDictionaries:(NSArray *)dictionaries;
- (void)setPointsDecreaseFromDictionaries:(NSArray *)dictionaries;
- (void)setHistoryFromDictionaries:(NSArray *)dictionaries;

@end

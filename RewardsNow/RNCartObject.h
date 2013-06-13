//
//  RNCartObject.h
//  RewardsNow
//
//  Created by Ethan Mick on 5/28/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RNRedeemObject;

@interface RNCartObject : NSObject

@property (nonatomic, strong) RNRedeemObject *redeemObject;
@property (nonatomic) NSInteger count;

- (void)addObject;
- (void)removeObject;
- (double)getTotalPrice;
- (NSString *)stringTotalPrice;
- (NSDictionary *)dictionaryForPlaceOrder;

@end

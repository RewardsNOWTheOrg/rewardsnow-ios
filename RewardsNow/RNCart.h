//
//  RNCart.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/18/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RNUser, RNRedeemObject;

@interface RNCart : NSObject

@property (nonatomic, strong) RNUser *user;
@property (nonatomic, strong) NSMutableArray *items;

+ (instancetype)sharedCart;
- (NSString *)getNamePoints;

- (NSNumber *)total;
- (NSString *)stringTotal;
- (NSString *)getCartImageName;
- (NSNumber *)pointsDifference;
- (NSString *)stringPointsDifference;
- (void)addToCart:(RNRedeemObject *)card;

@end

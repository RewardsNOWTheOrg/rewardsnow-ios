//
//  RNCart.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/18/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RNUser, RNGiftCard;

@interface RNCart : NSObject

@property (nonatomic, strong) RNUser *user;
@property (nonatomic, strong) NSMutableArray *items;

+ (instancetype)sharedCart;
- (NSString *)getNamePoints;

- (void)addToCart:(RNGiftCard *)card;

@end

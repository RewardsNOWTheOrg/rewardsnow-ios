//
//  RNCart.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/18/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RNUser;

@interface RNCart : NSObject

@property (nonatomic, strong) RNUser *user;

+ (instancetype)sharedCart;

@end

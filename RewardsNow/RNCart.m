//
//  RNCart.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/18/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNCart.h"
#import "RNRedeemObject.h"
#import "RNUser.h"

@implementation RNCart

+ (instancetype)sharedCart {
    static RNCart *_sharedWebService;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWebService = [[RNCart alloc] init];
    });
    
    return _sharedWebService;
}

- (instancetype)init {
    
    if ( (self = [super init]) ) {
        self.items = [NSMutableArray array];
        
    }
    return self;
}

- (NSString *)getNamePoints {
    return [NSString stringWithFormat:@"%@ Rewards: %@ points.", _user.firstName, _user.balance];
}

- (void)addToCart:(RNRedeemObject *)card {
    [_items addObject:card];
}


@end

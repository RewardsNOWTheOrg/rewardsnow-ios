//
//  RNCartObject.m
//  RewardsNow
//
//  Created by Ethan Mick on 5/28/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNCartObject.h"
#import "RNCart.h"
#import "RNRedeemObject.h"

@implementation RNCartObject

- (void)addObject {
    self.count++;
}

- (void)removeObject {
    self.count--;
    if (_count < 0) {
        _count = 0;
    }
}

- (double)getTotalPrice {
    return _count * _redeemObject.priceInPoints;
}

- (NSString *)stringTotalPrice {
    return [[RNCart sharedCart] formattedStringFromNumber:@([self getTotalPrice])];
}

- (NSDictionary *)dictionaryForPlaceOrder {
    return @{@"Item": _redeemObject.catalogCode, @"Quantity" : [NSString stringWithFormat:@"%d", _count]};
}

@end

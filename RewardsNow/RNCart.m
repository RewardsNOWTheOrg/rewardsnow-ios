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
#import "RNCartObject.h"

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

- (void)emptyCart {
    [self.items removeAllObjects];
}

- (NSString *)pointsStringBalance {
    return [self formattedStringFromNumber:_user.balance];
}

- (NSString *)getNamePoints {
    return [NSString stringWithFormat:@"%@: %@ points.", _user.fullName, [self pointsStringBalance]];
}

- (NSString *)getCartImageName {
    return _items.count > 0 ? @"cart-full.png" : @"cart-empty.png";
}

- (void)addToCart:(RNRedeemObject *)card {
    
    DLog(@"Added: %@", card);
    
    NSInteger index = [_items indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        RNCartObject *object = obj;
        return object.redeemObject.catalogID == card.catalogID;
    }];
    
    if (index != NSNotFound) {
        [_items[index] addObject];
    } else {
        RNCartObject *cartObject = [[RNCartObject alloc] init];
        cartObject.redeemObject = card;
        cartObject.count = 1;
        [_items addObject:cartObject];
    }
}

- (NSNumber *)total {
    double points = 0;
    for (RNCartObject *cartObject in _items) {
        points += [cartObject getTotalPrice];
    }
    return @(points);
}

- (NSString *)stringTotal {
    return [self formattedStringFromNumber:[self total]];
}

- (NSNumber *)pointsDifference {
    return @(_user.balance.doubleValue - self.total.doubleValue);
}

- (NSString *)stringPointsDifference {
    return [self formattedStringFromNumber:[self pointsDifference]];
}

- (NSString *)formattedStringFromNumber:(NSNumber *)num {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:[[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
    return [formatter stringFromNumber:num];
}

- (NSArray *)arrayForPlaceOrderItems {
    NSMutableArray *array = [NSMutableArray array];
    
    for (RNCartObject *cartObject in _items) {
        @try {
            [array addObject:[cartObject dictionaryForPlaceOrder]];
        }
        @catch (NSException *exception) {
            NSLog(@"There was an error creating a dictionary in place order: %@", exception);
        }
    }
    return array;
}

- (BOOL)hasItemsInCart {
    
    for (RNCartObject *cartObject in _items) {
        if (![cartObject isEmpty]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)canCheckout {
    return [self hasItemsInCart] && [[self pointsDifference] doubleValue] > 0;
}


@end

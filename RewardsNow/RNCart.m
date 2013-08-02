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
#import "RNWebService.h"
#import "RNResponse.h"

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

- (void)updateCartFromWeb;
{
    [[RNWebService sharedClient] getCartWithCallback:^(RNResponse *response) {
        if (response.wasSuccessful) {
            for (RNRedeemObject *redeem in response.result) {
                [self addToCart:redeem remote:NO callback:nil];
            }
        }
    }];
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

- (void)addToCart:(RNRedeemObject *)card remote:(BOOL)remote callback:(void (^)(BOOL result))callback;
{
    NSInteger index = [_items indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        RNCartObject *object = obj;
        return object.redeemObject.catalogID == card.catalogID;
    }];
    
    if (index != NSNotFound) {
        [_items[index] addObject];
    } else {
        ///
        /// The item has not been sent added yet, add it, and optionally send it up to the cloud
        ///
        RNCartObject *cartObject = [[RNCartObject alloc] init];
        cartObject.redeemObject = card;
        cartObject.count = 1;
        [_items addObject:cartObject];
        
        if (remote) {
            ///send
            [[RNWebService sharedClient] postCatalogIDToCart:[card catalogIDString] callback:^(RNResponse *result) {
                if (callback) {
                    callback([result.result boolValue]);
                }
            }];
        }
    }
}

- (void)removeItemAtIndex:(NSInteger)index callback:(void (^)(BOOL result))callback;
{
    ///
    /// Always try and remove it remotely too
    ///
    
    NSString *catalogID = [[self.items[index] redeemObject] catalogIDString];
    [self.items removeObjectAtIndex:index];
    
    [[RNWebService sharedClient] postRemoveItemFromCart:catalogID callback:^(RNResponse *result) {
        if (callback) {
            callback([result.result boolValue]);
        }
    }];
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
    
    for (RNCartObject *cartObject in [self itemsThatHaveQuantity]) {
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

- (NSArray *)itemsThatHaveQuantity {
    NSMutableArray *items = [NSMutableArray array];
    
    for (RNCartObject *object in _items) {
        if (![object isEmpty]) {
            [items addObject:object];
        }
    }
    
    return items;
}

- (void)logout;
{
    self.user = nil;
    [self.items removeAllObjects];
}

@end

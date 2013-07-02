//
//  RNWebService.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>

@class RNUser, RNResponse;

typedef void (^RNResultCallback)(RNResponse *result);

@interface RNWebService : AFHTTPClient

/**
 * 
 */
@property (nonatomic, copy) NSString *tipNumber;


+ (instancetype)sharedClient;

- (void)getRewardsWithCallback:(RNResultCallback)callback;
- (void)getDealsAtLocation:(CLLocation *)location query:(NSString *)query callback:(RNResultCallback)callback;
- (void)getDealsAtLocation:(CLLocation *)location query:(NSString *)query limit:(NSInteger)lim offset:(NSInteger)offset radius:(double)radius category:(NSNumber *)category callback:(RNResultCallback)callback;
- (void)getAccountStatementFrom:(NSDate *)from to:(NSDate *)to callback:(RNResultCallback)callback;
- (void)getProgramInfoWithCallback:(RNResultCallback)callback;
- (void)getLocalCategoriesWithCallback:(RNResultCallback)callback;
- (void)getAccountInfoWithTipWithCallback:(RNResultCallback)callback;
- (void)getBranding:(NSString *)code callback:(RNResultCallback)callback;
- (void)getCartWithCallback:(RNResultCallback)callback;

- (void)loginWithUsername:(NSString *)username password:(NSString *)password callback:(RNResultCallback)callback;

//????
- (void)putEmail:(NSString *)email callback:(RNResultCallback)callback;

- (void)postChangePasswordWithUsername:(NSString *)username oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword confirmPassword:(NSString *)confirmPassword callback:(RNResultCallback)callback;
- (void)postCatalogIDToCart:(NSNumber *)catalogID callback:(RNResultCallback)callback;
- (void)postPlaceOrderForUser:(RNUser *)user items:(NSArray *)redemptions  callback:(RNResultCallback)callback;


@end

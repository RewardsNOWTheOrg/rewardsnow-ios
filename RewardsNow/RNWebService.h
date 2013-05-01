//
//  RNWebService.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>

typedef void (^RNResultCallback)(id result);

@interface RNWebService : AFHTTPClient

+ (instancetype)sharedClient;

- (void)getRewards:(NSString *)tipFirst WithCallback:(RNResultCallback)callback;
- (void)getDeals:(NSString *)tipFirst location:(CLLocation *)location query:(NSString *)query callback:(RNResultCallback)callback;
- (void)getDeals:(NSString *)tipFirst location:(CLLocation *)location query:(NSString *)query limit:(NSInteger)lim offset:(NSInteger)offset radius:(double)radius callback:(RNResultCallback)callback;
- (void)getAccountStatementForTip:(NSString *)tip From:(NSDate *)from to:(NSDate *)to callback:(RNResultCallback)callback;

- (void)getAccountInfoWithTip:(NSNumber *)tip callback:(RNResultCallback)callback;
- (void)getBankFromCode:(NSString *)code callback:(RNResultCallback)callback;

- (void)loginWithUsername:(NSString *)username password:(NSString *)password code:(NSNumber *)code callback:(RNResultCallback)callback;

- (void)putEmail:(NSString *)email callback:(RNResultCallback)callback;
- (void)putPasswordFrom:(NSString *)password oldPassword:(NSString *)oldPassword retyped:(NSString *)retypedPassword callback:(RNResultCallback)callback;

@end

//
//  RNWebService.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "AFHTTPClient.h"

typedef void (^RNResultCallback)(id result);

@interface RNWebService : AFHTTPClient

+ (instancetype)sharedClient;

- (void)getRewards:(NSString *)tipFirst WithCallback:(RNResultCallback)callback;
- (void)getAccountStatementForTip:(NSString *)tip From:(NSDate *)from to:(NSDate *)to callback:(RNResultCallback)callback;

- (void)getAccountInfoWithTip:(NSNumber *)tip callback:(RNResultCallback)callback;

- (void)loginWithUsername:(NSString *)username password:(NSString *)password code:(NSNumber *)code callback:(RNResultCallback)callback;

@end

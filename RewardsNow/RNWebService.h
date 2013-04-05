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

@end

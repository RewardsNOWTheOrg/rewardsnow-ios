//
//  RNUser.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/18/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNObject.h"

@interface RNUser : RNObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, strong) NSNumber *balance;
@property (nonatomic, copy) NSArray *giftCards;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *apt;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zipCode;
@property (nonatomic, copy) NSString *username;

- (NSString *)stringBalance;
- (void)subtractPoints:(NSNumber *)points;

@end

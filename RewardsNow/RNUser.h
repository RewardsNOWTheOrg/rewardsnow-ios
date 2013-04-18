//
//  RNUser.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/18/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNObject.h"

/*
 "Info": {
 "AvailableBalance": 20012,
 "Email": "ssmith@rewardsnow.com",
 "FirstName": "SHAWN",
 "FullName": "SHAWN SMITH"
 }
 */

@interface RNUser : RNObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, strong) NSNumber *balance;
@property (nonatomic, copy) NSArray *giftCards;


@end

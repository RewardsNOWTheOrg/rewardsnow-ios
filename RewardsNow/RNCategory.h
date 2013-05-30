//
//  RNCategory.h
//  RewardsNow
//
//  Created by Ethan Mick on 5/28/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNObject.h"

@interface RNCategory : RNObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *merchantCategory;

@end

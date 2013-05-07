//
//  RNObject.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface RNObject : MTLModel <MTLJSONSerializing>

+ (NSUInteger)modelVersion;
+ (NSArray *)objectsFromJSON:(NSArray *)array;

- (NSString *)formattedStringFromNumber:(NSNumber *)num;

@end

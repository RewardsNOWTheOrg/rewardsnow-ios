//
//  RNObject.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNObject.h"

@implementation RNObject

+ (NSUInteger)modelVersion {
	return 1;
}

+ (NSArray *)objectsFromJSON:(NSArray *)array {
    NSMutableArray *created = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        
        NSError *error = nil;
        id object = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:dict error:&error];
        if (error) {
            DLog(@"Error Creating Object: %@", error);
        }
        
        if (object) {
            [created addObject:object];
        }
    }
    return created;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary dictionary];
}

- (NSString *)formattedStringFromNumber:(NSNumber *)num {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:[[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
    return [formatter stringFromNumber:num];
}

@end

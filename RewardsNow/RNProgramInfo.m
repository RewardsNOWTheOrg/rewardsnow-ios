//
//  RNProgramInfo.m
//  RewardsNow
//
//  Created by Ethan Mick on 5/20/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNProgramInfo.h"

@implementation RNProgramInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSMutableDictionary *fields = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [fields setValue:@"ProgramInfo.EarningPoints" forKey:@"earningPoints"];
    [fields setValue:@"ProgramInfo.FAQ" forKey:@"frequentlyAskedQuestions"];
    [fields setValue:@"ProgramInfo.Terms" forKey:@"terms"];
    return fields;
}


@end

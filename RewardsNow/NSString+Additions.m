//
//  NSString+Additions.m
//  Kermits
//
//  Created by Ethan Mick on 4/30/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//
// http://stackoverflow.com/questions/3436173/nsstring-is-empty
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (BOOL)isEmpty {
    if([self length] == 0) { //string is empty or nil
        return YES;
    }
    
    if(![[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        //string is all whitespace
        return YES;
    }
    
    return NO;
}

- (BOOL)isNotEmpty {
    return ![self isEmpty];
}

- (NSString *)leftPadding {
    return [NSString stringWithFormat:@" %@", self];
}

- (NSString *)rightPadding {
    return [NSString stringWithFormat:@"%@ ", self];
}

@end

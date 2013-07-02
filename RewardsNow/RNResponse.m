//
//  RNResponse.m
//  RewardsNow
//
//  Created by Ethan Mick on 7/2/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNResponse.h"

@implementation RNResponse

- (id)init {
    
    if ( (self = [super init]) ) {
        _wasSuccessful = NO;
    }
    return self;
}

- (id)initWithResult:(id)aResult statusCode:(NSInteger)statusCode {
    
    if ( (self = [self init]) ) {
        self.result = aResult;
        self.statusCode = statusCode;
        _wasSuccessful = [self isSuccessful:statusCode];
    }
    return self;
}

- (id)initWithError:(NSError *)error errorString:(NSString *)errorString statusCode:(NSInteger)statusCode {
    
    if ( (self = [self init]) ) {
        self.error = error;
        self.errorString = errorString;
        self.statusCode = statusCode;
        _wasSuccessful = [self isSuccessful:statusCode];
    }
    return self;
}

- (BOOL)isSuccessful:(NSInteger)statusCode {
    return statusCode >= 200 && statusCode < 300;
}

@end

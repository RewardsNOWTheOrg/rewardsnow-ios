//
//  RNResponse.h
//  RewardsNow
//
//  Created by Ethan Mick on 7/2/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Encapsulates the response from the RewardsNow API
 */
@interface RNResponse : NSObject

@property (nonatomic, readonly) BOOL wasSuccessful;

/**
 * The result, which is only populated if the call was successful.
 */
@property (nonatomic, strong) id result;

/**
 * The error that is associated with the request. nil if no error occured.
 */
@property (nonatomic, strong) NSError *error;

/**
 * The error returned from the RewardsNOW request.
 */
@property (nonatomic, strong) NSString *errorString;

/*
 * The status code of the request.
 */
@property (nonatomic) NSInteger statusCode;


- (id)initWithResult:(id)aResult statusCode:(NSInteger)statusCode;
- (id)initWithError:(NSError *)error errorString:(NSString *)errorString statusCode:(NSInteger)statusCode;

@end

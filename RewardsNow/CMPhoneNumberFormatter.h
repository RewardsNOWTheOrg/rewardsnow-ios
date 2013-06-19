//
//  CMPhoneNumberFormatter.h
//  CMUtilities
//
//  Created by Ethan Mick on 6/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMPhoneNumberFormatter : NSObject

+ (NSString *)formattedPhoneNumberToNationalUS:(NSString *)number;

@end

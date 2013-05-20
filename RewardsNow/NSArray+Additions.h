//
//  NSArray+Additions.h
//  EpiPen
//
//  Created by Ethan Mick on 5/9/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Additions)

- (NSString *)componentsJoinedByString:(NSString *)separator forMethod:(SEL)method;

@end

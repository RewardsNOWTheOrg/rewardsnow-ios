//
//  RNConstants.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define C(color) (float)color/255.0
#define MapSpanSize 0.05
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

FOUNDATION_EXPORT NSString *const BankCodeKey;
FOUNDATION_EXPORT NSString *const kImageDidFinishDownloadingNotification;

@interface RNConstants : NSObject

+ (NSArray *)radii;

@end

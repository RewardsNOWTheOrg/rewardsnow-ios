//
//  CMUtilities.h
//  CMUtilities
//
//  Created by Ethan Mick on 5/16/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "UIImage+additions.h"
#import "NSArray+Additions.h"
#import "NSString+Additions.h"
#import "CMTextField.h"
#import "CMLabel.h"
#import "UIColor+Additions.h"

#pragma mark - Useful Macros

#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width;
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height;
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define C(color) (float)color/255.0

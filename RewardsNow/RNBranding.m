//
//  RNBranding.m
//  RewardsNow
//
//  Created by Ethan Mick on 5/15/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNBranding.h"

#define kNumberOfColorValues 3

@implementation RNBranding

static RNBranding *_sharedBranding;

+ (instancetype)sharedBrandingFromDictionary:(NSDictionary *)dictionary {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSError *error = nil;
        id object = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:dictionary error:&error];
        if (error) {
            DLog(@"Error Creating Object: %@", error);
        }
        
        _sharedBranding = object;
    });
    
    return _sharedBranding;
}

+ (instancetype)sharedBranding {
    NSAssert(_sharedBranding != nil, @"You must instantiate the Branding Object before calling this method!");
    return _sharedBranding;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSMutableDictionary *fields = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [fields setValue:@"css_background_color" forKey:@"backgroundColor"];
    [fields setValue:@"css_header_image" forKey:@"headerURL"];
    [fields setValue:@"css_menu_bg_color" forKey:@"menuBackgroundColor"];
    [fields setValue:@"css_points_color" forKey:@"pointsColor"];
    [fields setValue:@"css_submit_button_color" forKey:@"submitButtonColor"];
    [fields setValue:@"css_tab_bar_text_color" forKey:@"tabBarTextColor"];
    [fields setValue:@"css_text_color" forKey:@"textColor"];
    return fields;
}

+ (MTLValueTransformer *)RGBColorTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSString *string) {
        
        NSCharacterSet *extraChars = [NSCharacterSet characterSetWithCharactersInString:@"rgb()"];
        NSString *fixedString = [string stringByTrimmingCharactersInSet:extraChars];
        NSArray *numbers = [fixedString componentsSeparatedByString:@","];
        
        if (numbers.count >= 3) {
            return [UIColor colorWithRed:C([numbers[0] integerValue]) green:C([numbers[1] integerValue]) blue:C([numbers[2] integerValue]) alpha:1.0];
        } else {
            return nil;
        }
    }];
}

+ (NSValueTransformer *)headerURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)backgroundColorJSONTransformer {
    return [self RGBColorTransformer];
}

+ (NSValueTransformer *)menuBackgroundColorJSONTransformer {
    return [self RGBColorTransformer];
}

+ (NSValueTransformer *)pointsColorJSONTransformer {
    return [self RGBColorTransformer];
}

+ (NSValueTransformer *)submitButtonColorJSONTransformer {
    return [self RGBColorTransformer];
}

+ (NSValueTransformer *)tabBarTextColorJSONTransformer {
    return [self RGBColorTransformer];
}

+ (NSValueTransformer *)textColorJSONTransformer {
    return [self RGBColorTransformer];
}

@end

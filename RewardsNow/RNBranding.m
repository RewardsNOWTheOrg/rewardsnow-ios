//
//  RNBranding.m
//  RewardsNow
//
//  Created by Ethan Mick on 5/15/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNBranding.h"
#import "RNConstants.h"

#define kNumberOfColorValues 3
#define kImageName @"header_image"

NSString *const RNBrandingPersistenceKey = @"com.rewardsnow.RNBrandingPersistenceKey";

@implementation RNBranding

static RNBranding *_sharedBranding;

+ (instancetype)sharedBrandingFromDictionary:(NSDictionary *)dictionary {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSError *error = nil;
        id object = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:dictionary error:&error];
        if (error) {
            DLog(@"Error Creating Object: %@", error);
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:object] forKey:RNBrandingPersistenceKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        _sharedBranding = object;
    });
    
    return _sharedBranding;
}

+ (instancetype)sharedBranding {
    
    if (_sharedBranding == nil) {
        id object = [[NSUserDefaults standardUserDefaults] objectForKey:RNBrandingPersistenceKey];
        _sharedBranding = [NSKeyedUnarchiver unarchiveObjectWithData:object];
    }
    
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

- (void)setHeaderURL:(NSURL *)headerURL {
    _headerURL = headerURL;
    self.headerImage = [self getImageFromURL:_headerURL];
    [self saveImage:_headerImage withFileName:kImageName ofType:_headerURL.lastPathComponent.pathExtension inDirectory:@"image"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kImageDidFinishDownloadingNotification object:self];
}

- (void)globalBranding {
    
    [[UITabBar appearance] setTintColor:self.menuBackgroundColor];
    [[UITabBar appearance] setBackgroundImage:[self imageFromColor:self.menuBackgroundColor withSize:CGSizeMake(1, 44)]];
    [[UISearchBar appearance] setBackgroundImage:[self imageFromColor:self.menuBackgroundColor withSize:CGSizeMake(1, 44)]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[self imageFromColor:self.menuBackgroundColor withSize:CGSizeMake(1, 44)] forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTintColor:self.menuBackgroundColor];
    
//    [[UILabel appearance] setTextColor:self.textColor];
//    [[UILabel appearance] setBackgroundColor:self.pointsColor];
//    [[UILabel appearanceWhenContainedIn:[UITextField class], nil] setBackgroundColor:[UIColor clearColor]];
//    [[UILabel appearanceWhenContainedIn:[UIButton class], nil] setBackgroundColor:[UIColor clearColor]];
//    [[UILabel appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundColor:[UIColor clearColor]];
//    
//    [[UITextView appearance] setTextColor:self.textColor];
//    
//    [[UITextField appearance] setTextColor:self.pointsColor];
//    [[UITextField appearance] setBackgroundColor:self.tabBarTextColor];
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor clearColor]];
//    
//    [[UIButton appearance] setBackgroundColor:self.pointsColor];
//    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundColor:[UIColor clearColor]];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : self.tabBarTextColor } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : self.tabBarTextColor } forState:UIControlStateHighlighted];    
}

- (UIColor *)commonBackgroundColor {
    return [UIColor whiteColor];
}

#pragma mark - Get Image

- (UIImage *)getImageFromURL:(NSURL *)fileURL {
    UIImage *result;
    
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    result = [UIImage imageWithData:data];
    
    return result;
}

- (void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        DLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

- (UIImage *)loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    return result;
}

#pragma mark - Image Creation

- (UIImage *)imageFromColor:(UIColor *)color withSize:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end

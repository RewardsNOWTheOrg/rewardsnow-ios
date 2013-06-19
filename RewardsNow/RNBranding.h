//
//  RNBranding.h
//  RewardsNow
//
//  Created by Ethan Mick on 5/15/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNObject.h"
/*
 
 "Brandings": {
 "css_background_color": "rgb(138,178,213)",
 "css_header_image": "https://www.rewardsnow.com/programfiles/images/980header.jpg",
 "css_menu_bg_color": "rgb(94,128,192)",
 "css_points_color": "rgb(204,0,0)",
 "css_submit_button_color": "rgb(140,156,184)",
 "css_tab_bar_text_color": "rgb(255,240,0)",
 "css_text_color": "rgb(51,48,0)"
 },

 */

@interface RNBranding : RNObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *menuBackgroundColor;
@property (nonatomic, strong) UIColor *pointsColor;
@property (nonatomic, strong) UIColor *submitButtonColor;
@property (nonatomic, strong) UIColor *tabBarTextColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSURL *headerURL;
@property (nonatomic, strong) UIColor *commonBackgroundColor;

@property (nonatomic, strong) UIImage *headerImage;

- (void)globalBranding;

+ (instancetype)sharedBrandingFromDictionary:(NSDictionary *)dictionary;
+ (instancetype)sharedBranding;

- (UIImage *)imageFromColor:(UIColor *)color withSize:(CGSize)size;

@end

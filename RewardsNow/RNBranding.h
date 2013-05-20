//
//  RNBranding.h
//  RewardsNow
//
//  Created by Ethan Mick on 5/15/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNObject.h"
/*
 {
 "Brandings":[
 {"Name":"css_background_color","Value":"#8ab2d5"},
 {"Name":"css_header_image","Value":"https:\/\/www.rewardsnow.com\/programfiles\/images\/980header.jpg"},
 {"Name":"css_menu_bg_color","Value":"#5E80c0"},
 {"Name":"css_points_color","Value":"#CC0000"},
 {"Name":"css_submit_button_color","Value":"#8C9CB8"},
 {"Name":"css_tab_bar_text_color","Value":"#fff"},
 {"Name":"css_text_color","Value":"#333"}],"Error":null
 }
 */

@interface RNBranding : RNObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *menuBackgroundColor;
@property (nonatomic, strong) UIColor *pointsColor;
@property (nonatomic, strong) UIColor *submitButtonColor;
@property (nonatomic, strong) UIColor *tabBarTextColor;
@property (nonatomic, strong) UIColor *textColor;

@end

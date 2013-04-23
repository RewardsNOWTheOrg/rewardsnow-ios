//
//  RNAccountStatementDetailView.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/23/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNAccountStatementDetailView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

- (void)addLeftText:(NSString *)left rightText:(NSString *)right;

@end

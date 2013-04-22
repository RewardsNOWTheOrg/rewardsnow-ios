//
//  RNAccountViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAccountViewController.h"
#import "RNCart.h"
#import "RNUser.h"
#import "RNGiftCard.h"

@interface RNAccountViewController ()

@end

@implementation RNAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [[RNCart sharedCart] user];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.nameLabel.text = self.user.fullName;
    self.emailLabel.text = self.user.email;
    self.topPointsLabel.text = [NSString stringWithFormat:@"%@ Rewards: You have %@ points.", self.user.firstName, self.user.balance];
    
    for (NSInteger i = 0; i < self.user.giftCards.count; i++) {
        RNGiftCard *card = self.user.giftCards[i];
        UILabel *gcLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30 + (30 * i), 200, 30)];
        
        NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle setAlignment:NSTextAlignmentLeft];
        
        NSMutableParagraphStyle *mutParaStyle2 = [[NSMutableParagraphStyle alloc] init];
        [mutParaStyle2 setAlignment:NSTextAlignmentRight];
        
        
        NSString *string = [NSString stringWithFormat:@"%@%@", card.cardDescription, card.cardNumber];
//        DLog(@"D: %@ N: %@", card.cardDescription, card.cardNumber);
//        DLog(@"Range: %@", NSStringFromRange(NSMakeRange([card.cardDescription length], [string length] - 3)));
//        DLog(@"Length: %d", [string length]);
//        
//        
//        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
//        [text addAttributes:@{NSParagraphStyleAttributeName: mutParaStyle} range:NSMakeRange(0, [card.cardDescription length])];
//        [text addAttributes:@{NSParagraphStyleAttributeName: mutParaStyle2} range:NSMakeRange([card.cardDescription length], [string length] - 3)];
        
        gcLabel.text = string;
        [self.giftCardView addSubview:gcLabel];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end

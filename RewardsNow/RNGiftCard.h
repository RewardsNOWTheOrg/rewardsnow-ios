//
//  RNGiftCard.h
//  RewardsNow
//
//  Created by Ethan Mick on 4/18/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNObject.h"

/*
 
 "Description": "$25 JC Penney eGift Card",
 "GiftCardNumber": "6006492001232167308"
 */

@interface RNGiftCard : RNObject

@property (nonatomic, copy) NSString *cardDescription;
@property (nonatomic, strong) NSNumber *cardNumber;
@property (nonatomic, strong) NSURL *cardURL;

@end

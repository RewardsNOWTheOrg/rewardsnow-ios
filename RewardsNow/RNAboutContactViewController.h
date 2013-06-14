//
//  RNAboutContactViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 5/20/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "RNSkinableViewController.h"

@interface RNAboutContactViewController : RNSkinableViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *skinnableButtons;

- (IBAction)writeTapped:(id)sender;
- (IBAction)callTapped:(id)sender;

@end

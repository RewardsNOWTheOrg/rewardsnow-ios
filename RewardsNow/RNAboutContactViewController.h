//
//  RNAboutContactViewController.h
//  RewardsNow
//
//  Created by Ethan Mick on 5/20/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface RNAboutContactViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *callButton;

- (IBAction)writeTapped:(id)sender;
- (IBAction)callTapped:(id)sender;

@end

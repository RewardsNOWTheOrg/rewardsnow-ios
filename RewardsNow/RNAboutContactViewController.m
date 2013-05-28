//
//  RNAboutContactViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 5/20/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAboutContactViewController.h"

@interface RNAboutContactViewController ()

@end

@implementation RNAboutContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)writeTapped:(id)sender {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"Rewards Inquiry from Mobile Application"];
    [controller setToRecipients:@[@"CustomerSatisfaction@rewardsnow.com"]];
    if (controller) [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)callTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://5853543779"]];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

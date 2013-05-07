//
//  RNCartAccountViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNCartAccountViewController.h"

@interface RNCartAccountViewController ()

@end

@implementation RNCartAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

    if (textField.tag > 1) {
        CGRect frame = self.view.frame;
        frame.origin.y = -100;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = frame;
        }];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    [self endEditing];
    return YES;
}

- (void)endEditing {
    [self.view endEditing:YES];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = frame;
    }];
}


@end

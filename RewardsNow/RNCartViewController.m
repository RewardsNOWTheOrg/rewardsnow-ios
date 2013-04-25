//
//  RNCartViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNCartViewController.h"
#import "RNCartConfirmationViewController.h"

@interface RNCartViewController ()

@end

@implementation RNCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

- (IBAction)confirmTapped:(id)sender {
    
    ///
    /// Is possible to order?
    ///
    
    RNCartConfirmationViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RNCartConfirmationViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RNCartOverviewCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

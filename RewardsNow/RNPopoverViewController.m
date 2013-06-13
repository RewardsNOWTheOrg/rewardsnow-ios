//
//  RNPopoverViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 6/7/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNPopoverViewController.h"
#import "RNConstants.h"

@interface RNPopoverViewController ()

@end

@implementation RNPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PopupCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[RNConstants radii][indexPath.row] description];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(popoverDidFinishWithIndexPathSelected:)]) {
        [self.delegate popoverDidFinishWithIndexPathSelected:indexPath];
    }
}

@end

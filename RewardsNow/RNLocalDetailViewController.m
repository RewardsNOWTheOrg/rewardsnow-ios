//
//  RNLocalDetailViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/5/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNLocalDetailViewController.h"
#import "RNLocalAdditionalViewController.h"

@interface RNLocalDetailViewController ()

@end

@implementation RNLocalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(320, 700);
    DLog(@"Sup: %@", NSStringFromCGRect(self.scrollView.frame));
    DLog(@"Size: %@", NSStringFromCGSize(self.scrollView.contentSize));
}

- (IBAction)directionsTapped:(id)sender {
    
}

#pragma mark - UITableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"LocalDealDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = @[@"Call", @"Visit", @"Additional Information"][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            //call
            break;
        }
        case 1:
        {
            /// visit
            break;
        }
        default:
        {
            RNLocalAdditionalViewController *more = [self.storyboard instantiateViewControllerWithIdentifier:@"RNLocalAdditionalViewController"];
            [self.navigationController pushViewController:more animated:YES];
            break;
        }
    }
}


@end

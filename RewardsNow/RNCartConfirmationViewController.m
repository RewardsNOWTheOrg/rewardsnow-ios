//
//  RNCartConfirmationViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNCartConfirmationViewController.h"
#import "RNRedeemObject.h"
#import "RNCart.h"
#import "MBProgressHUD.h"
#import "RNCartThanksViewController.h"

@interface RNCartConfirmationViewController ()

@end

@implementation RNCartConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topPointsLabel.text = [[RNCart sharedCart] getNamePoints];
    
    NSArray *items = [[RNCart sharedCart] items];
    
    for (NSInteger i = 0; i < items.count; i++) {
        [self createLabelWithText:[items[i] descriptionName] points:[items[i] stringPriceInPoints] number:i];
    }
    
    self.pointsTotal.text = [[RNCart sharedCart] stringTotal];
    [self resizeView];

}

- (void)resizeView {
    CGFloat difference = self.innerViewHeight.constant - self.innerInnerViewHeight.constant;

    self.innerInnerViewHeight.constant = (30 * [[[RNCart sharedCart] items] count]) + 60;
    
    
    self.innerViewHeight.constant = self.innerInnerViewHeight.constant + difference;
    self.scrollView.contentSize = CGSizeMake(320, self.innerInnerViewHeight.constant + 100);
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320, self.innerInnerViewHeight.constant + 100);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320, self.innerViewHeight.constant);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createLabelWithText:(NSString *)text points:(NSString *)points number:(NSUInteger)num {
    
    UILabel *left = [[UILabel alloc] initWithFrame:CGRectMake(10, 5 + (num * 30), 220, 30)];
    left.text = text;
    left.minimumScaleFactor = 0.5;
    left.backgroundColor = [UIColor clearColor];
    [_labelView addSubview:left];
    
    UILabel *right = [[UILabel alloc] initWithFrame:CGRectMake(230, 5 + (num * 30), 50, 30)];
    right.textColor = [UIColor redColor];
    right.textAlignment = NSTextAlignmentRight;
    right.text = points;
    right.backgroundColor = [UIColor clearColor];
    [_labelView addSubview:right];
    
}

- (IBAction)cartTapped:(id)sender {
    UIViewController *controller = self.navigationController.viewControllers[0];
    [self.navigationController popToViewController:controller animated:YES];
}

- (IBAction)deliveryTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)placeOrderTapped:(id)sender {
    NSString *message = [NSString stringWithFormat:@"Are you sure you would like to place the order for %@?", [[RNCart sharedCart] stringTotal]];
    [[[UIAlertView alloc] initWithTitle:@"Place Order" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 1:
        {
            /// YES
            //place order
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.detailsLabelText = @"Ordering...";
            
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                RNCartThanksViewController *thanks = [self.storyboard instantiateViewControllerWithIdentifier:@"RNCartThanksViewController"];
                [self.navigationController pushViewController:thanks animated:YES];
            });
            
            
            break;
        }
            
        default: { break; }
    }
}

@end

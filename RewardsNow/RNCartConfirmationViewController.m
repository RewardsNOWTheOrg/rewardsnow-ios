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
#import "RNCartObject.h"
#import "RNUser.h"
#import "RNWebService.h"

@interface RNCartConfirmationViewController ()


@property (nonatomic, strong) RNUser *user;

@end

@implementation RNCartConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topPointsLabel.text = [[RNCart sharedCart] getNamePoints];
    self.user = [[RNCart sharedCart] user];
    
    NSArray *items = [[RNCart sharedCart] items];
    
    for (NSInteger i = 0; i < items.count; i++) {
        RNCartObject *cartObject = items[i];
        NSString *title = [[cartObject.redeemObject descriptionName] stringByAppendingFormat:@" x%d", cartObject.count];
        [self createLabelWithText:title points:[cartObject stringTotalPrice] number:i];
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
    left.font = [UIFont systemFontOfSize:16];
    left.text = text;
    left.minimumScaleFactor = 0.25;
    left.adjustsFontSizeToFitWidth = YES;
    left.backgroundColor = [UIColor clearColor];
    [_labelView addSubview:left];
    
    UILabel *right = [[UILabel alloc] initWithFrame:CGRectMake(230, 5 + (num * 30), 50, 30)];
    right.textColor = [UIColor colorWithRed:C(180) green:C(14) blue:C(14) alpha:1.0];
    right.textAlignment = NSTextAlignmentRight;
    right.adjustsFontSizeToFitWidth = YES;
    right.minimumScaleFactor = 0.5;
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
            
            ///
            /// The Checkout Process
            /// 1: Add all items to the cart
            /// 2: When finished, call checkout with the same items.
            ///
            
            RNCart *cart = [RNCart sharedCart];
            __block NSInteger count = 0;
            
            for (RNCartObject *object in cart.items) {
                
                [[RNWebService sharedClient] postCatalogIDToCart:object.redeemObject.catalogID callback:^(id result) {
                    count++;
                    if (count == cart.items.count) {
                        [self checkoutCartItems];
                    }
                }];
            }
            
            break;
        }
            
        default: { break; }
    }
}

- (void)checkoutCartItems {
    
    [[RNWebService sharedClient] postPlaceOrderForUser:_user items:[[RNCart sharedCart] arrayForPlaceOrderItems] callback:^(id result) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([result boolValue]) { //succcess
            RNCart *cart = [RNCart sharedCart];
            [_user subtractPoints:[cart total]]; //more application?
            [cart emptyCart];
                        
            RNCartThanksViewController *thanks = [self.storyboard instantiateViewControllerWithIdentifier:@"RNCartThanksViewController"];
            [self.navigationController pushViewController:thanks animated:YES];
            
            //if we are waiting for the checkout process to be done...
            // we should show the thank you screen...
            // and then drop it down automaticalyl wit hthe new gift cards?
        } else { //fail
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, an error occurred during checkout." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        }
        
    }];
}

@end

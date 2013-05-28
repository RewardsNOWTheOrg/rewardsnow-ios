//
//  RNCartViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/6/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNCartViewController.h"
#import "RNCartConfirmationViewController.h"
#import "RNCart.h"
#import "RNUser.h"
#import "RNCartCell.h"
#import "RNRedeemObject.h"
#import "UIImageView+AFNetworking.h"
#import "RNCartObject.h"

#define kCellIsBeingDeletedTag NSIntegerMax


@interface RNCartViewController ()

@property (nonatomic, strong) RNCart *cart;

@end

@implementation RNCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cart = [RNCart sharedCart];
    self.topPointsLabel.text = [_cart getNamePoints];
    [self updatePriceLabels];
    [self resizeView:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

- (BOOL)canMoveForwardInCheckout {
    return _cart.items.count > 0 && [[_cart pointsDifference] doubleValue] > 0;
}

- (void)updatePriceLabels {
    self.pointsAvailableLabel.text = [_cart.user stringBalance];
    self.pointsInCartLabel.text = [_cart stringTotal];
    self.pointsLeftLabel.text = [_cart stringPointsDifference];
    
    self.checkoutButton.enabled = [self canMoveForwardInCheckout];
    self.topButtonForward.enabled = [self canMoveForwardInCheckout];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.scrollView.contentOffset = CGPointZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

- (void)resizeView:(BOOL)animate {
    
    void(^animations)() = ^{
        CGFloat difference = self.innerViewHeight.constant - self.tableHeight.constant;
        self.tableHeight.constant = self.tableView.rowHeight * _cart.items.count;
        self.innerViewHeight.constant = self.tableHeight.constant + difference;
        self.scrollView.contentSize = CGSizeMake(320, self.innerViewHeight.constant);
        [self.view layoutIfNeeded];
    };
    
    if (animate) {
        [UIView animateWithDuration:0.25 animations:animations];
    } else {
        animations();
    }
}

- (IBAction)confirmTapped:(id)sender {
    [self.view endEditing:YES];
    RNCartConfirmationViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RNCartAccountViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag != kCellIsBeingDeletedTag) {
        RNCartCell *cell = (RNCartCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
        cell.stepper.value = [textField.text doubleValue];
        [_cart.items[textField.tag] setCount:textField.text.integerValue];
        [self updatePriceLabels];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    RNCartCell *cell = (RNCartCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    [_scrollView  setContentOffset:CGPointMake(0, cell.frame.origin.y) animated:YES];
}

- (IBAction)stepperChanged:(UIStepper *)sender {
    RNCartCell *cell = (RNCartCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    cell.textView.text = [NSString stringWithFormat:@"%d", (NSInteger)sender.value];
    [_cart.items[sender.tag] setCount:sender.value];
    [self updatePriceLabels];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cart.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RNCartOverviewCell";

    RNCartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    RNCartObject *co = _cart.items[indexPath.row];
    
    cell.upperLabel.text = [co.redeemObject descriptionName];
    cell.lowerLabel.text = [NSString stringWithFormat:@"%d points", (NSInteger)[co getTotalPrice]];
    [cell.cellImageView setImageWithURL:[NSURL URLWithString:[[co.redeemObject imageURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    cell.stepper.value = co.count;
    cell.stepper.tag = indexPath.row;
    cell.textView.text = [NSString stringWithFormat:@"%d", co.count];
    cell.textView.tag = indexPath.row;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    RNCartCell *cell = (RNCartCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.textView.tag = kCellIsBeingDeletedTag;
    [_cart.items removeObjectAtIndex:indexPath.row];
//    [tableView beginUpdates];
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [tableView endUpdates];
    [self.tableView reloadData];
    [self updatePriceLabels];
    [self resizeView:YES];
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}

#pragma mark - UIKeyboard display event handlers

- (void)keyboardWillShow:(NSNotification *)notification {
    [self setViewMovedUp:YES withNotification:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self setViewMovedUp:NO withNotification:notification];
}

//method to move the view up/down whenever the keyboard is shown/dismissed
- (void)setViewMovedUp:(BOOL)movedUp withNotification:(NSNotification *)notification {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.scrollView.frame;
        CGRect keyboardFrame;
        NSUInteger keyboardHeight = 0;
        CGFloat topMovement = -70;
        
        CGRect frame = self.view.frame;
        
        if (movedUp) {
            [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
            keyboardHeight = keyboardFrame.size.height;
            
            
            // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
            // 2. increase the size of the view so that the area behind the keyboard is covered up.
            rect.size.height -= (keyboardHeight + topMovement);
            DLog(@"Changed: %d", keyboardHeight);
            frame.origin.y = topMovement;
        } else {
            [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
            keyboardHeight = keyboardFrame.size.height;
            
            // revert back to the normal state.
            rect.size.height += (keyboardHeight + topMovement);
            frame.origin.y = 0;
        }
        self.view.frame = frame;
        self.scrollView.frame = rect;
    }];
}


@end
                                
                                 

//
//  RNAuthPasswordViewController.m
//  RewardsNow
//
//  Created by Ethan Mick on 4/18/13.
//  Copyright (c) 2013 CloudMine LLC. All rights reserved.
//

#import "RNAuthPasswordViewController.h"
#import "RNWebService.h"
#import "MBProgressHUD.h"


@interface RNAuthPasswordViewController ()

@property (nonatomic, copy) NSArray *textFields;

@end

@implementation RNAuthPasswordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFields = @[_answerTextField, _passwordTextField, _confirmPasswordTextField, _usernameTextField, _nameTextField];
    self.resetButton.enabled = [self canSubmit];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[RNWebService sharedClient] getSecretQuestion:@"@969999999999999" callback:^(id result) {
        
        if (result != nil) {
            self.questionLabel.text = result;
        } else {
            //error
        }

        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:self.innerView.frame.size];
    
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (BOOL)canSubmit {
    for (UITextField *field in _textFields) {
        if ([field.text isEmpty]) {
            return NO;
        }
    }
    return YES;
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
        
        if (movedUp) {
            [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
            keyboardHeight = keyboardFrame.size.height;
            
            // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
            // 2. increase the size of the view so that the area behind the keyboard is covered up.
            rect.size.height -= (keyboardHeight);
        } else {
            [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
            keyboardHeight = keyboardFrame.size.height;
            
            // revert back to the normal state.
            rect.size.height += (keyboardHeight);
        }
        self.scrollView.frame = rect;
    }];
}


- (IBAction)textDidChange:(UITextField *)sender {
    self.resetButton.enabled = [self canSubmit];
}

- (IBAction)resetTapped:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RNWebService sharedClient] postResetPassword:@"969"
                                            answer:_answerTextField.text
                                          password:_passwordTextField.text
                                   passwordConfirm:_confirmPasswordTextField.text
                                          username:_usernameTextField.text
                                          fullName:_nameTextField.text
                                          callback:^(id result) {
        DLog(@"Result %@", result);
                                              if ([result boolValue]) {
                                                  
                                              } else {
                                                  
                                              }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
@end

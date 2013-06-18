//
//  EditViewController.m
//  SimpleSample-users-ios
//
//  Created by Alexey Voitenko on 13.03.12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController () <QBActionStatusDelegate, UITextFieldDelegate>
- (IBAction) update:(id)sender;
- (IBAction) back:(id)sender;
- (IBAction) hideKeyboard:(id)sender;

@property (nonatomic, weak) IBOutlet UITextField* loginFiled;
@property (nonatomic, weak) IBOutlet UITextField* fullNameField;
@property (nonatomic, weak) IBOutlet UITextField* phoneField;
@property (nonatomic, weak) IBOutlet UITextField* emailField;
@property (nonatomic, weak) IBOutlet UITextField* websiteField;
@property (nonatomic, weak) IBOutlet UITextField *tagsField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak,nonatomic) UITextField* activeField;
@end

@implementation EditViewController


- (void)viewDidUnload {
    self.tagsField = nil;
    self.fullNameField = nil;
    self.phoneField = nil;
    self.emailField = nil;
    self.websiteField = nil;
    self.tagsField = nil;
    
    [self setScrollView:nil];
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.loginFiled.text    = self.user.login;
    self.fullNameField.text = self.user.fullName;
    self.phoneField.text    = self.user.phone;
    self.emailField.text    = self.user.email;
    self.websiteField.text  = self.user.website;
    
    for (NSString *tag in self.user.tags) {
        if([self.tagsField.text length] == 0) {
            self.tagsField.text = tag;
        } else {
            self.tagsField.text = [NSString stringWithFormat:@"%@, %@", self.tagsField.text, tag];
        }
    }
    
    [self registerForKeyboardNotifications];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.loginFiled resignFirstResponder];
    [self.fullNameField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.websiteField resignFirstResponder];
}

- (IBAction) hideKeyboard:(id)sender {
    [sender resignFirstResponder];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.scrollView.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin)) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y - kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


// Update user
- (void)update:(id)sender {    
    if ([self.loginFiled.text length] != 0) {
        self.user.login = self.loginFiled.text;
    }
    
    if ([self.fullNameField.text length] != 0) {
        self.user.fullName = self.fullNameField.text;
    }
    
    if ([self.phoneField.text length] != 0) {
        self.user.phone = self.phoneField.text;
    }
    
    if ([self.emailField.text length] != 0) {
        self.user.email = self.emailField.text;
    }
    
    if ([self.websiteField.text length] != 0) {
        self.user.website = self.websiteField.text;
    }
    
    if  ([self.tagsField.text length] != 0) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[[self.tagsField.text stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@","]];
        self.user.tags = array;
    }
    
    // update user
    [QBUsers updateUser:self.user delegate:self];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (IBAction)back:(id)sender {
    self.loginFiled.text = nil;
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
- (void)completedWithResult:(Result *)result {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // Edit user result
    if ([result isKindOfClass:[QBUUserResult class]]) {
        // Success result
        if (result.success) { 
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil 
                                                            message:@"User was edit successfully" 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles:nil, nil];
            [alert show];
                       
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userUpdatedSuccessfully" object:nil userInfo:@{@"user" : self.user}];
        
        // Errors
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                    message:[result.errors description]
                                                    delegate:nil 
                                                    cancelButtonTitle:@"Okay" 
                                                    otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

#pragma mark -
#pragma mark QBActionStatusDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
}

@end

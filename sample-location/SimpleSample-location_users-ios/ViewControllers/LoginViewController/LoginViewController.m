//
//  LoginViewController.m
//  SimpleSample-location_users-ios
//
//  Created by Igor Khomenko on 04.10.11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "LoginViewController.h"
#import "DataManager.h"

@interface LoginViewController () <QBActionStatusDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *login;
@property (nonatomic, weak) IBOutlet UITextField *password;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)next:(id)sender;
- (IBAction)back:(id)sender;

@end

@implementation LoginViewController


- (void)viewDidUnload {
    [self setLogin:nil];
    [self setPassword:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// User Sign In
- (IBAction)next:(id)sender {
    // Authenticate user
    [QBUsers logInWithUserLogin:self.login.text password:self.password.text delegate:self];
    
    [self.activityIndicator startAnimating];
}

- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)loginWithFaceBook:(id)sender {
    [QBUsers logInWithSocialProvider:@"facebook" scope:nil delegate:self];
}

- (IBAction)loginWithTwitter:(id)sender {
    [QBUsers logInWithSocialProvider:@"twitter" scope:nil delegate:self];
}

#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
-(void)completedWithResult:(Result *)result {
    // QuickBlox User authenticate result
    if([result isKindOfClass:[QBUUserLogInResult class]]){

        // Success result
		if(result.success){
            QBUUserLogInResult *res = (QBUUserLogInResult *)result;
            
            // save current user
            
            [[DataManager shared] setCurrentUser:[res user]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentification successful"
                                                            message:nil
                                                            delegate:self
                                                            cancelButtonTitle:@"Ok"
                                                            otherButtonTitles: nil];
            [alert show];
            
        // Errors
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                            message:[result.errors description]
                                                            delegate:self
                                                            cancelButtonTitle:@"Ok"
                                                            otherButtonTitles: nil];
            alert.tag = 1;
            [alert show];
        
        }
    }
    
    [self.activityIndicator stopAnimating];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)_textField {
    [_textField resignFirstResponder];
    [self next:nil];
    return YES;
}

#pragma mark -
#pragma mark Touches processing

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.password resignFirstResponder];
    [self.login resignFirstResponder];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag != 1){
        [self dismissModalViewControllerAnimated:YES];
    }
}

@end
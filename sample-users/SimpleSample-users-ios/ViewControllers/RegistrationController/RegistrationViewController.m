//
//  RegistrationViewController.m
//  SimpleSample-users-ios
//
//  Created by Igor Khomenko on 04.10.11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "RegistrationViewController.h"


@implementation RegistrationViewController
@synthesize userName;
@synthesize password;
@synthesize activityIndicator;

- (void)viewDidUnload
{
    [self setUserName:nil];
    [self setPassword:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [password resignFirstResponder];
    [userName resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// User Sign Up
- (IBAction)next:(id)sender 
{
    // Create QuickBlox User entity
    QBUUser *user = [QBUUser user]; 
	user.password = password.text;
    user.login = userName.text;
    
    // create User
	[QBUsers signUp:user delegate:self];
    
    [activityIndicator startAnimating];
}

- (IBAction)back:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
-(void)completedWithResult:(Result*)result{
    // QuickBlox User creation result
    if([result isKindOfClass:[QBUUserResult class]]){
        
        // Success result
		if(result.success){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration was successful. Please now sign in." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [alert release];
		
        // Errors
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors" 
                                                            message:[result.errors description]
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
		}
	}	
    
    [activityIndicator stopAnimating];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)_textField
{
    [_textField resignFirstResponder];
    [self next:nil];
    return YES;
}


#pragma mark
#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     [self dismissModalViewControllerAnimated:YES];
}

@end
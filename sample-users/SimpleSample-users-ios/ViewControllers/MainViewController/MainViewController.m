//
//  MainViewController.m
//  SimpleSample-users-ios
//
//  Created by Alexey Voitenko on 24.02.12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "MainViewController.h"
#import "UserDetailsViewController.h"
#import "LoginViewController.h"
#import "EditViewController.h"
#import "CustomTableViewCellCell.h"
#import "RegistrationViewController.h"

@class UserDetailsViewController;
@class EditViewController;
@class LoginViewController;
@class RegistrationViewController;

@interface MainViewController () <QBActionStatusDelegate, UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    UIBarButtonItem *signInButton;
    UIBarButtonItem *signUpButton;
    UIBarButtonItem *logoutButton;
    UIBarButtonItem *editButton;
}

@property (nonatomic, strong) NSArray* users;
@property (nonatomic, strong) NSMutableArray* searchUsers;

@property (nonatomic, weak) IBOutlet UITableView* myTableView;
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

- (void) retrieveUsers;

- (IBAction) signIn:(id)sender;
- (IBAction) signUp:(id)sender;
- (IBAction) edit:(id)sender;
- (IBAction) logout:(id)sender;

- (void) loggedIn;
- (void) notLoggedIn;

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    signInButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign in" style:UIBarButtonItemStyleBordered target:self action:@selector(signIn:)];
    signUpButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign up" style:UIBarButtonItemStyleBordered target:self action:@selector(signUp:)];
    logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout:)];
    editButton  = [[UIBarButtonItem alloc] initWithTitle:@"Self edit" style:UIBarButtonItemStyleBordered target:self action:@selector(edit:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoggedInSuccessfully:) name:@"userLoggedInSuccessfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userUpdatedSuccessfully:) name:@"userUpdatedSuccessfully" object:nil];

    
    [self notLoggedIn];
    
    // retrieve users
    [self retrieveUsers];
}

- (void)viewDidUnload {
    self.toolBar = nil;
    self.searchBar = nil;
    self.myTableView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([segue.identifier isEqualToString:@"userDetailsSegue"]) {
        CustomTableViewCellCell *cell = (CustomTableViewCellCell *)sender;
        NSIndexPath *selectedIndexPath = [self.myTableView indexPathForCell:cell];
        
        UserDetailsViewController *detailsController = segue.destinationViewController;
        detailsController.choosedUser = [self.searchUsers objectAtIndex:[selectedIndexPath row]];
    } else if ([segue.identifier isEqualToString:@"editSegue"]) {
        EditViewController *editController = segue.destinationViewController;
        
        editController.user = self.currentUser;
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// User Sign In
- (IBAction)signIn:(id)sender {
//    // show User Sign In controller
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

// User Sign Up
- (IBAction) signUp:(id)sender {
//    // show User Sign Up controller
    [self performSegueWithIdentifier:@"registrationSegue" sender:self];
}

// Logout User
- (IBAction)logout:(id)sender {
    self.currentUser = nil;
    // logout user
    [QBUsers logOutWithDelegate:nil];
    
    [self notLoggedIn];
}

- (IBAction)edit:(id)sender {
    [self performSegueWithIdentifier:@"editSegue" sender:self];
}

- (void)notLoggedIn {
    NSArray *items = [NSArray arrayWithObjects:signInButton, signUpButton, nil];
    [self.toolBar setItems:items animated:NO];
}

- (void)loggedIn {
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 170;
    NSArray *items = [NSArray arrayWithObjects: editButton, fixedSpace, logoutButton, nil];
    
    [self.toolBar setItems:items animated:NO];
}

// Retrieve QuickBlox Users
- (void) retrieveUsers {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // retrieve 100 users
    PagedRequest* request = [[PagedRequest alloc] init];
    request.perPage = 100;
	[QBUsers usersWithPagedRequest:request delegate:self];
}

// QuickBlox API queries delegate
- (void)completedWithResult:(Result *)result {
    // Retrieve Users result
    if ([result isKindOfClass:[QBUUserPagedResult class]]) {
        // Success result
        if (result.success) {
            // update table
            QBUUserPagedResult *usersSearchRes = (QBUUserPagedResult *)result;
            self.users = usersSearchRes.users;
            self.searchUsers = [self.users mutableCopy];
            [self.myTableView reloadData];
        
        // Errors
        } else {
            NSLog(@"Errors=%@", result.errors); 
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}


#pragma mark -
#pragma mark TableViewDataSource & TableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];
     
    CustomTableViewCellCell *selectedCell = (CustomTableViewCellCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"userDetailsSegue" sender:selectedCell];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchUsers count];
}

// Making table view using custom cells 
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    CustomTableViewCellCell* cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];

    QBUUser* obtainedUser = [self.searchUsers objectAtIndex:[indexPath row]];
    if(obtainedUser.login != nil){
        cell.userLogin.text = obtainedUser.login;
    } else {
         cell.userLogin.text = obtainedUser.email;
    }
    
    for(NSString *tag in obtainedUser.tags){
        if([cell.userTag.text length] == 0){
             cell.userTag.text = tag;
        }else{
            cell.userTag.text = [NSString stringWithFormat:@"%@, %@", cell.userTag.text, tag];
        }
    }
    
    return cell;
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void) searchBarSearchButtonClicked:(UISearchBar *)SearchBar {
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self.searchUsers removeAllObjects];
    
    if ([searchText length] == 0) {
        [self.searchUsers addObjectsFromArray:self.users];
    } else {
       
        [self.users enumerateObjectsUsingBlock:^(QBUUser* user, NSUInteger idx, BOOL *stop) {
            BOOL result = [self field:user.login containsSearchText:searchText];
            
            result = result || [self field:user.fullName containsSearchText:searchText];
            
            if (user.tags.count > 0) {
                result = result || [self field:user.tags.description containsSearchText:searchText];
            }
            
            if (result) {
                [self.searchUsers addObject:user];
            }
        }];
    }
    
    [self.myTableView reloadData];
}

- (BOOL)field:(NSString *)fieldText containsSearchText:(NSString *)searchBarText {
    NSRange searchRange = NSMakeRange(NSNotFound, 0);
    if (searchBarText && fieldText) {
        searchRange = [fieldText rangeOfString:searchBarText options:NSCaseInsensitiveSearch];
    }
    return searchRange.location != NSNotFound;
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)_textField {
    [_textField resignFirstResponder];
    return YES;
}

- (void)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (void)userLoggedInSuccessfully:(NSNotification *)notification {
    QBUUser* loggedInUser = [notification.userInfo objectForKey:@"user"];
    
    self.currentUser = loggedInUser;
    
    [self loggedIn];
}

- (void)userUpdatedSuccessfully:(NSNotification *)notification {
    QBUUser* updatedUser = [notification.userInfo objectForKey:@"user"];
    self.currentUser = updatedUser;
}

@end

//
//  MainViewController.m
//  SimpleSample-messages_users-ios
//
//  Created by Igor Khomenko on 2/16/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "MainViewController.h"
#import "RichContentViewController.h"
#import "PushMessage.h"
#import "CustomCell.h"

@interface MainViewController () <UIAlertViewDelegate,
                                  QBActionStatusDelegate,
                                  UIPickerViewDelegate,
                                  UIPickerViewDataSource,
                                  UITableViewDataSource,
                                  UITableViewDelegate,
                                  UITextFieldDelegate>

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, weak) IBOutlet UITextField *messageBody;
@property (nonatomic, weak) IBOutlet UITableView *receivedMassages;
@property (nonatomic, weak) IBOutlet UILabel *toUserName;
@property (nonatomic, weak) IBOutlet UIPickerView *usersPickerView;

- (IBAction)sendButtonDidPress:(id)sender;
- (IBAction)selectUserButtonDidPress:(id)sender;
- (IBAction)buttonRichClicked:(UIButton*)sender;

- (void) showPickerWithUsers;

@end

@implementation MainViewController

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidUnload {
    
    self.messageBody = nil;
    self.receivedMassages = nil;
    self.toUserName = nil;
    self.usersPickerView = nil;
    self.receivedMassages = nil;
    
    [super viewDidUnload];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPushDidReceive object:nil];
}

- (NSMutableArray*)messages {
    if (!_messages) {
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.receivedMassages.layer.cornerRadius = 5;
    
    [self performSegueWithIdentifier:@"splashSegue" sender:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushDidReceive:) 
                                                 name:kPushDidReceive object:nil];
}

- (void)pushDidReceive:(NSNotification *)notification {
    // new push notification did receive - show it
    
    // push message
    NSString *message = [[notification userInfo] objectForKey:@"message"];
    
    // push rich content
    NSString *pushRichContent = [[notification userInfo] objectForKey:@"rich_content"];
    
    PushMessage *pushMessage = [PushMessage pushMessageWithMessage:message richContentFilesIDs:pushRichContent];
    [self.messages addObject:pushMessage];

    [self.receivedMassages reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

// Send push notification
- (IBAction)sendButtonDidPress:(id)sender {

    // not selected receiver(user)
   if ([self.toUserName.text length] == 0 || [_users count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select user." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
    // empty text
    } else if([self.messageBody.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter some text" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    
    // send push
    } else {
        
        // Create message
        NSString *mesage = [NSString stringWithFormat:@"%@: %@", 
                            ((QBUUser *)[_users objectAtIndex:[self.usersPickerView selectedRowInComponent:0]]).login,
                            self.messageBody.text];
        
        // receiver (user id)
        NSUInteger userID = ((QBUUser *)[_users objectAtIndex:[self.usersPickerView selectedRowInComponent:0]]).ID;
        
        // Send push
        [QBMessages TSendPushWithText:mesage 
                             toUsers:[NSString stringWithFormat:@"%d", userID] 
                            delegate:self];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        [self.messageBody resignFirstResponder];
    }
}

// Select receiver
- (IBAction)selectUserButtonDidPress:(id)sender {
    if (_users != nil) {
         [self showPickerWithUsers];
        
    // retrieve all users
    } else {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        // Retrieve QuickBlox users for current application
        PagedRequest *pagetRequest = [[PagedRequest alloc] init];
        pagetRequest.perPage = 30;
        [QBUsers usersWithPagedRequest:pagetRequest delegate:self];
    }
}

- (void)showPickerWithUsers {
    [self.usersPickerView reloadAllComponents];
    [self.usersPickerView setHidden:NO];
    [self.view bringSubviewToFront:self.usersPickerView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.messageBody resignFirstResponder];
}

#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
- (void)completedWithResult:(Result*)result {
    // QuickBlox get Users result
    
    if ([result isKindOfClass:[QBUUserPagedResult  class]]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        // Success result
		if (result.success) {
            
            // save users & show picker
            QBUUserPagedResult *res = (QBUUserPagedResult  *)result;
            self.users = res.users;
            [self showPickerWithUsers];
        
        // Errors
		} else {
            NSLog(@"Errors=%@", result.errors);
		}
        
    
    // Send Push result
    } else if ([result isKindOfClass:[QBMSendPushTaskResult class]]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        // Success result
        if(result.success) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message sent successfully" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            
        // Errors
        } else {
            NSLog(@"Errors=%@", result.errors);
        }
    }
}

- (IBAction)buttonRichClicked:(UIButton*)tappedButton {
    // Show rich content
    [self performSegueWithIdentifier:@"richSegue" sender:tappedButton];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"richSegue"]) {
        UIButton* tappedButton = (UIButton *)sender;
        
        RichContentViewController* richContentViewController = segue.destinationViewController;
        richContentViewController.message = [self.messages objectAtIndex:tappedButton.tag];
    }
}


#pragma mark -
#pragma mark UIPickerViewDataSource & UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_users count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    QBUUser* user = [self.users objectAtIndex:row];
    return user.login;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.toUserName setText: ((QBUUser *)[_users objectAtIndex:row]).login];
    [self.usersPickerView setHidden:YES];
}


#pragma mark -
#pragma mark TableViewDataSource & TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PushCell";
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    PushMessage *pushMessage = [self.messages objectAtIndex:indexPath.row];
    
    if ([[pushMessage richContentFilesIDs] count] > 0) {
        [cell.richContentButton setHidden:NO];
        [cell.richContentButton setTag:indexPath.row];
    }

    cell.pushText.text = [pushMessage message];
    
    return cell;
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.messageBody resignFirstResponder];
    return YES;
}

@end

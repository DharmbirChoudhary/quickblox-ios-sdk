//
//  NoteDetailsViewController.m
//  SimpleSample-custom-object-ios
//
//  Created by Ruslan on 9/14/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "NoteDetailsViewController.h"

@interface NoteDetailsViewController ()<QBActionStatusDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITextView *comentsTextView;

- (IBAction)addComment:(id)sender;
- (IBAction)changeStatus:(id)sender;
- (IBAction)deleteNote:(id)sender;

@end



@implementation NoteDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
    
    self.title = @"Note";
    
}

- (void)viewDidUnload {
    [self setNoteLabel:nil];
    [self setStatusLabel:nil];
    [self setComentsTextView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Interface methods

- (IBAction)addComment:(id)sender {
    // Show alert for enter new comment
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New comment"
                                                    message:@"\n"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add", nil];
    
    UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 31.0)];
    [theTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [theTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [theTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [theTextField setBackgroundColor:[UIColor whiteColor]];
    [theTextField setTextAlignment:UITextAlignmentCenter];
    theTextField.tag = 101;
    [alert addSubview:theTextField];
    
    [alert show];
}

- (IBAction)changeStatus:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select status"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"New", @"In Progress", @"Done", nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)deleteNote:(id)sender {
    // remove note
    [QBCustomObjects deleteObjectWithID: self.customObject.ID className:customClassName delegate:self];
    
    [[[DataManager shared] notes] removeObjectIdenticalTo:self.customObject];
}

- (void)reloadData {
    // set note & status
    self.noteLabel.text = self.customObject.fields[@"note"];
    self.statusLabel.text = self.customObject.fields[@"status"];
    
    // set comments
    NSString *commentsAsString = [self.customObject fields][@"comment"];
    if  (![commentsAsString isKindOfClass:NSNull.class]) {
        NSArray *comments = [commentsAsString componentsSeparatedByString:@"-c-"];
        [self.comentsTextView setText:nil];
        int count = 1;
        for (NSString *comment in comments) {
            if (![comment isEqualToString:@""]) {
                if (count == 1) {
                    NSString *str = [[NSString alloc] initWithFormat:@"#%d %@\n\n",count, comment];
                    [self.comentsTextView setText:str];
                } else {
                    NSString *str = [[NSString alloc] initWithFormat:@"%@#%d %@\n\n", self.comentsTextView.text, count, comment];
                    [self.comentsTextView setText:str];
                }
                count++;
            }
        }
    }
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *status = nil;
    switch (buttonIndex) {
        case 0: {
            status = @"New";
            break;
        }
        case 1: {
            status = @"In Progress";
            break;
        }
        case 2: {
            status = @"Done";
            break;
        }
    }
    
    if (status) {
        // chabge status & update custom object
        self.customObject.fields[@"status"] = status;
        [QBCustomObjects updateObject:self.customObject delegate:self];
        
        // refresh table
        [self reloadData];
    }
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // delete note alert
    if (alertView.tag == 2) {
        [self.navigationController popViewControllerAnimated:YES];
        
    // Add new comment alert
    } else {
        switch (buttonIndex) {
            case 1: {
                
                NSString* noteComment = self.customObject.fields[@"comment"];
                NSString* alertText = ((UITextField *)[alertView viewWithTag:101]).text;
                // change comments & update custom object
                
                if (alertText && ![alertText isEqualToString:@""]) {
                    NSString *comments = nil;
                    
                    if (!noteComment || [noteComment isKindOfClass:[NSNull class]]) {
                        comments = [[NSString alloc] initWithFormat:@"%@-c-",alertText];
                    }
                    
                    else
                        comments = [[NSString alloc] initWithFormat:@"%@-c-%@", noteComment,alertText];
                    
                    self.customObject.fields[@"comment"] = comments;
                    
                    [QBCustomObjects updateObject:self.customObject delegate:self];
                    
                    // refresh table
                    [self reloadData];
                }
                else {
                    [self showAlertWithOKButtonAndText:@"You cannot leave empty comment!"];
                }
                
                break;
            }
            default:
                break;
        }
    }
}

- (void)showAlertWithOKButtonAndText:(NSString *)text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
- (void)completedWithResult:(Result*)result {
    
    // Update/Delete note result
    if ([result isKindOfClass:QBCOCustomObjectResult.class]) {
        
        // Success result
        if (result.success) {
            QBCOCustomObjectResult *res = (QBCOCustomObjectResult *)result;
            
            if (!res.object) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note successfully deleted"
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert setTag:2];
                [alert show];
                
            }
        }
    }
}


@end

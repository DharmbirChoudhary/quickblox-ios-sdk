//
//  UserDetailsViewController.m
//  SimpleSample-users-ios
//
//  Created by Alexey Voitenko on 13.03.12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "UserDetailsViewController.h"

@interface UserDetailsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *lastRequestAtLabel;
@property (nonatomic, weak) IBOutlet UILabel *loginLabel;
@property (nonatomic, weak) IBOutlet UILabel *fullNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;
@property (nonatomic, weak) IBOutlet UILabel *websiteLabel;
@property (nonatomic, weak) IBOutlet UILabel *tagLabel;

- (IBAction)back:(id)sender;
@end

@implementation UserDetailsViewController


- (void)viewDidUnload {
    self.lastRequestAtLabel = nil;
    self.loginLabel = nil;
    self.fullNameLabel = nil;
    self.phoneLabel = nil;
    self.emailLabel = nil;
    self.websiteLabel = nil;
    self.tagLabel = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Show User's details
    self.loginLabel.text = self.choosedUser.login;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    self.lastRequestAtLabel.text = [dateFormatter stringFromDate:self.choosedUser.lastRequestAt ?
                               self.choosedUser.lastRequestAt : self.choosedUser.createdAt];
    
    self.fullNameLabel.text = self.choosedUser.fullName;
    self.phoneLabel.text = self.choosedUser.phone;
    self.emailLabel.text = self.choosedUser.email;
    self.websiteLabel.text = self.choosedUser.website;
    
    for(NSString *tag in self.choosedUser.tags) {
        if([self.tagLabel.text length] == 0) {
            self.tagLabel.text = tag;
        }
        else {
            self.tagLabel.text = [NSString stringWithFormat:@"%@, %@", self.tagLabel.text, tag];
        }
    }
    
    if ([self.choosedUser.fullName length] == 0) {
        self.fullNameLabel.text = @"empty";
        self.fullNameLabel.alpha = 0.3;
    }
    
    if ([self.choosedUser.phone length] == 0) {
        self.phoneLabel.text = @"empty"; 
        self.phoneLabel.alpha = 0.3;
    }
    
    if ([self.choosedUser.email length] == 0) {
        self.emailLabel.text = @"empty"; 
        self.emailLabel.alpha = 0.3;
    }
    
    if ([self.choosedUser.website length] == 0) {
        self.websiteLabel.text = @"empty"; 
        self.websiteLabel.alpha = 0.3;
    }
    
    if ([self.choosedUser.tags count] == 0) {
        self.tagLabel.text = @"empty";
        self.tagLabel.alpha = 0.3;
    }
}

- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end

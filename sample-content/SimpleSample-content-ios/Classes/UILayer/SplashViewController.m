//
//  SplashViewController.m
//  SimpleSample-Content
//
//  Created by kirill on 7/17/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "SplashViewController.h"
#import "MainViewController.h"

@interface SplashViewController ()<QBActionStatusDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SplashViewController


#pragma mark -
#pragma mark UIViewController lifecycle methods 

- (void)viewDidLoad {
    [super viewDidLoad];
    [_activityIndicator startAnimating];
    
    // Your app connects to QuickBlox server here.
    //
    // QuickBlox session creation   
    
    [self createQBSession];
    
    if(IS_HEIGHT_GTE_568){
        CGRect frame = self.activityIndicator.frame;
        frame.origin.y += 44;
        [self.activityIndicator setFrame:frame];
    }
}

- (void)viewDidUnload {
    [self setActivityIndicator:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


#pragma mark -
#pragma mark Interface methods

-(void)hideSplashScreen {
    [_activityIndicator stopAnimating];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark QBActionStatusDelegate

- (void)createQBSession {
    QBASessionCreationRequest *extendedAuthRequest = [[QBASessionCreationRequest alloc] init];
    extendedAuthRequest.userLogin = @"emma";
    extendedAuthRequest.userPassword = @"emma";
    
    [QBAuth createSessionWithExtendedRequest:extendedAuthRequest delegate:self];
}

// QuickBlox API queries delegate
- (void)completedWithResult:(Result *)result {
    // Success result
    if(result.success){
        
        // QuickBlox session creation  result
        if ([result isKindOfClass:[QBAAuthSessionCreationResult class]]) {
            
            // Success result
            if(result.success){
                
                // send request for getting user's filelist
                PagedRequest *pagedRequest = [[PagedRequest alloc] init];    
                [pagedRequest setPerPage:10];
                
                [QBContent blobsWithPagedRequest:pagedRequest delegate:self];
                
            }
        
        // Get User's files result
        } else if ([result isKindOfClass:[QBCBlobPagedResult class]]) {
            
            // Success result
            if(result.success){
                QBCBlobPagedResult *res = (QBCBlobPagedResult *)result; 
                
                // Save user's filelist
                [DataManager instance].fileList = [res.blobs mutableCopy];
                
                // hid splash screen
                [self performSelector:@selector(hideSplashScreen) withObject:self afterDelay:1];
            }
        }
    }
}

@end

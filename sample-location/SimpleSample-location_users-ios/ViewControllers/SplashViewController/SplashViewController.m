//
//  SplashViewController.m
//  SimpleSample-location_users-ios
//
//  Created by Danil on 04.10.11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "SplashViewController.h"
#import "AppDelegate.h"
#import "DataManager.h"

@interface SplashViewController ()<QBActionStatusDelegate>

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *wheel;

@end

@implementation SplashViewController 

- (void)viewDidUnload {
    self.wheel = nil;

    [super viewDidUnload];
}

- (void) viewDidLoad {
    // Your app connects to QuickBlox server here.
    // QuickBlox session creation
    [QBAuth createSessionWithDelegate:self];
    
    [super viewDidLoad];
    
    if (IS_HEIGHT_GTE_568) {
        CGRect frame = self.wheel.frame;
        frame.origin.y += 44;
        [self.wheel setFrame:frame];
    }
}

- (void)hideSplash {
    [self.wheel stopAnimating];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"tabBarSegue" sender:self];
    });    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
- (void)completedWithResult:(Result *)result {
    
    // QuickBlox application authorization result
    if ([result isKindOfClass:[QBAAuthSessionCreationResult class]]) {
        
        // Success result
        if (result.success) {
                        
            // retrieve users' points
            // create QBLGeoDataSearchRequest entity
            QBLGeoDataGetRequest *getRequest = [[QBLGeoDataGetRequest alloc] init];
            getRequest.lastOnly = YES; // Only last location
            getRequest.perPage = 70; // only 70 points
            getRequest.sortBy = GeoDataSortByKindCreatedAt;
            
            // retieve user's points
            [QBLocation geoDataWithRequest:getRequest delegate:self];
            
        // show Errors
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", "")
                                                message:[result.errors description]
                                                delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", "")
                                                otherButtonTitles:nil];
            [alert show];
        }
        // Retrieve users' points result
    } else if ([result isKindOfClass:[QBLGeoDataPagedResult class]]) {
        
        // Success result
        if (result.success) {
            // Hide splash & show main controller
            QBLGeoDataPagedResult *geoDataGetRes = (QBLGeoDataPagedResult *)result;
            [DataManager shared].checkinArray  = [geoDataGetRes.geodata mutableCopy];

            [self performSelector:@selector(hideSplash) withObject:nil afterDelay:1];
        // Errors
        } else{
            NSLog(@"Errors=%@", result.errors);
        }
    }
}

@end
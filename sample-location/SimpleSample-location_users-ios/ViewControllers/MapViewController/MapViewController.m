//
//  MapViewController.m
//  SimpleSample-location_users-ios
//
//  Created by Alexey Voitenko on 24.02.12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "MapViewController.h"
#import "MapPin.h"
#import "DataManager.h"

@interface MapViewController () <QBActionStatusDelegate, UIAlertViewDelegate,UITextFieldDelegate> {
    CLLocationManager* locationManager;
}

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

- (IBAction) checkIn:(id)sender;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
}

-(void)viewWillAppear:(BOOL)animated{
     // add pins to map
    if([self.mapView.annotations count] <= 1){        
        [[DataManager shared].checkinArray enumerateObjectsUsingBlock:^(QBLGeoData* geodata, NSUInteger idx, BOOL *stop) {
            CLLocationCoordinate2D coord = {.latitude = geodata.latitude,
                                            .longitude = geodata.longitude};

            MapPin *pin = [[MapPin alloc] initWithCoordinate:coord];
            pin.subtitle = geodata.status;
            pin.title = geodata.user.login ? geodata.user.login : geodata.user.email;
            [self.mapView addAnnotation:pin];
        }];
    }
}

// Show checkin view
- (IBAction) checkIn:(id)sender {
    
    // Show alert if user did not logged in
    
    if ([DataManager shared].currentUser == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You must first be authorized."
                                                        message:nil
                                                        delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                        otherButtonTitles:@"Sign Up", @"Sign In", nil];
        alert.tag = 1;
        [alert show];

    // Show alert for check in
    }
    else {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter your message"
                                                        message:@"\n"
                                                        delegate:self
                                                        cancelButtonTitle:@"Canсel"
                                                        otherButtonTitles:@"Check In", nil];
        alert.tag = 2;
        
        // add text field to alert
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 31.0)];
        [theTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [theTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [theTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [theTextField setBackgroundColor:[UIColor whiteColor]];
        [theTextField setTextAlignment:UITextAlignmentCenter];
        [theTextField setDelegate:self];
        theTextField.tag = 101;
        
        [alert addSubview:theTextField];
        [alert show];
    }
}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
- (void)completedWithResult:(Result *)result  {
     
     if ([result isKindOfClass:[QBLGeoDataResult class]]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        // Success result
        if (result.success) {
            QBLGeoDataResult *geoDataRes = (QBLGeoDataResult *)result;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check in was successful!"
                                                        message:[NSString stringWithFormat:@"Your coordinates: \n Latitude: %g \n Longitude: %g",
                                                                 geoDataRes.geoData.latitude,
                                                                 geoDataRes.geoData.longitude]
                                                        delegate:self 
                                                        cancelButtonTitle:@"Ok" 
                                                        otherButtonTitles: nil];
            [alert show];
            
        // Errors
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check in wasn't successful"
                                                        message:[result.errors description]
                                                        delegate:self 
                                                        cancelButtonTitle:@"Ok" 
                                                        otherButtonTitles: nil];
            [alert show];
        }
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // User didn't auth  alert
    if(alertView.tag == 1) {
        switch (buttonIndex) {
            case 1:
                [self performSegueWithIdentifier:@"registrationSegue" sender:self];
                break;
            case 2:
                [self performSegueWithIdentifier:@"loginSegue" sender:self];
                break;
            default:
                break;
        }
        
    // Check in   alert
    }
    else if(alertView.tag == 2){
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            
            // Check in
            //
            // create QBLGeoData entity
            QBLGeoData *geoData = [QBLGeoData geoData];
            geoData.latitude = locationManager.location.coordinate.latitude;
            geoData.longitude = locationManager.location.coordinate.longitude;
            geoData.status = ((UITextField *)[alertView viewWithTag:101]).text;
            
            // post own location
            [QBLocation createGeoData:geoData delegate:self];

        }        
    }
}


@end

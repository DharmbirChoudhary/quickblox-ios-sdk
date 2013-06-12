//
//  LatestCheckinsViewController.m
//  SimpleSample-location_users-ios
//
//  Created by Tatyana Akulova on 9/18/12.
//
//

#import "LatestCheckinsViewController.h"
#import "AppDelegate.h"
#import "SplashViewController.h"
#import "DataManager.h"
#import "LoginViewController.h"
#import "CustomCell.h"

@interface LatestCheckinsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation LatestCheckinsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[DataManager shared].checkinArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBLGeoData *geodata = [[DataManager shared].checkinArray objectAtIndex:indexPath.row];
        
    static NSString *CellIdentifier = @"Checkins";
    	
     CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell.avatar setImage:[UIImage imageNamed:@"pin.png"]];
    
    if (geodata.user.login != nil) {
        [cell.name setText:geodata.user.login];
    }
    else{
        [cell.name setText:geodata.user.fullName];
    }
    
    [cell.checkinMessage setText:geodata.user.fullName];
        
    return cell;
}


@end

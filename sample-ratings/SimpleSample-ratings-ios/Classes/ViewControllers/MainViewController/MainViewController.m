//
//  MainViewController.m
//  SimpleSample-ratings-ios
//
//  Created by Ruslan on 9/11/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "MainViewController.h"
#import "CustomTableViewCell.h"
#import "RateView.h"
#import "MovieDetailsViewController.h"
#import "Movie.h"
#import "DataManager.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MainViewController

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSegueWithIdentifier:@"splashSegue" sender:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainControllerWillUpdateTable) name:@"mainControllerWillUpdateTable" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"movieDetailsSegue"]) {
        CustomTableViewCell *selectedCell = (CustomTableViewCell *)sender;
        NSIndexPath* indexPath = [self.tableView indexPathForCell:selectedCell];
        
        MovieDetailsViewController* detailsController = segue.destinationViewController;
        
        Movie *selectedMovie = [[DataManager shared].movies objectAtIndex:indexPath.row];
        [detailsController setMovie:selectedMovie];
    }
}

#pragma mark -
#pragma mark TableViewDataSource & TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell* cell = (CustomTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"movieDetailsSegue" sender:cell];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell* cell = (CustomTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"movieDetailsSegue" sender:cell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[DataManager shared] movies] count];
}

// Making table view using custom cells
- (UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    CustomTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    Movie *movie = [[[DataManager shared] movies] objectAtIndex:indexPath.row];
    
    // Show movie's label, image & rate
    [cell.movieName setText:(NSString *)[movie movieName]];
    [cell.movieImageView setImage:[UIImage imageNamed:[movie movieImage]]];
    if([movie rating]){
        cell.ratingView.rate = [movie rating];
    }
    
    return cell;
}

- (void)mainControllerWillUpdateTable {
    [self.tableView reloadData];
}

@end

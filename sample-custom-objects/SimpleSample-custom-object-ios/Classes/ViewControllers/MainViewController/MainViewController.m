//
//  MainViewController.m
//  SimpleSample-custom-object-ios
//
//  Created by Ruslan on 9/14/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "MainViewController.h"
#import "NoteDetailsViewController.h"
#import "NewNoteViewController.h"
#import "CustomTableViewCell.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *searchArray;

- (IBAction)addNewNote:(id)sender;

@end

@implementation MainViewController

- (id)init {
    self = [super init];
    
    if (self) {
    }
    return self;
}

- (NSMutableArray*)searchArray {
    if (!_searchArray) {
        _searchArray = [[NSMutableArray alloc] init];
    }
    
    return _searchArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performSegueWithIdentifier:@"splashSegue" sender:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.searchArray removeAllObjects];
    [self.searchArray addObjectsFromArray:[[DataManager shared] notes]];
    [self.tableView reloadData];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (IBAction)addNewNote:(id)sender {
    [self performSegueWithIdentifier:@"newNoteSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"noteDetailsSegue"]) {
        CustomTableViewCell* selectedCell = (CustomTableViewCell*)sender;
        
        NSIndexPath* selectedIndexPath = [self.tableView indexPathForCell:selectedCell];
        
        QBCOCustomObject* selectedObject = [[DataManager shared].notes objectAtIndex:selectedIndexPath.row];
        
        ((NoteDetailsViewController *)segue.destinationViewController).customObject = selectedObject;
    }
}


#pragma mark -
#pragma mark TableViewDataSource & TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];
        
    CustomTableViewCell* selectedCell = (CustomTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];

    [self performSegueWithIdentifier:@"noteDetailsSegue" sender:selectedCell];    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchArray count];
}

// Making table view using custom cells
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    CustomTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
   
    // set note name & status
    [cell.noteLabel setText:[[[self.searchArray objectAtIndex:indexPath.row] fields] objectForKey:@"note"]];
    [cell.statusLabel setText:[[[self.searchArray objectAtIndex:indexPath.row] fields] objectForKey:@"status"]];
    
    // set createdAt/updatedAt date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MMMM-dd HH:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    NSString *stringFromDate;
    
    QBCOCustomObject* customObject = [[[DataManager shared] notes] objectAtIndex:indexPath.row];
    
    if ([customObject updatedAt]) {
        stringFromDate = [formatter stringFromDate:[[self.searchArray objectAtIndex:indexPath.row] updatedAt]];
    }
    else {
        stringFromDate = [formatter stringFromDate:[[self.searchArray objectAtIndex:indexPath.row] createdAt]];
    }
    [cell.dateLabel setText:stringFromDate];
    
    return cell;
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)SearchBar {
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self.searchArray removeAllObjects];
    
    if([searchText length] == 0) {
        [self.searchArray addObjectsFromArray:[[DataManager shared] notes]];
        [self.searchBar resignFirstResponder];
        
    // search
    } else {
        for (QBCOCustomObject *object in [[DataManager shared] notes]) {
            NSRange note = [[object.fields objectForKey:@"note"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(note.location != NSNotFound){
                [self.searchArray addObject:object];
            }
        }
    }
    
    [self.tableView reloadData];
}

@end

//
//  MovieDetailsViewController.m
//  SimpleSample-ratings-ios
//
//  Created by Ruslan on 9/11/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "Movie.h"
#import "DataManager.h"


@interface MovieDetailsViewController () <QBActionStatusDelegate>

@property (weak, nonatomic) IBOutlet UITextView *detailsText;
@property (weak, nonatomic) IBOutlet UIImageView *moviImageView;
@property (weak, nonatomic) IBOutlet UIButton *ratingButton;

@property (nonatomic, strong) RateView *ratingView;
@property (nonatomic, strong) RateView *alertRatingView;

- (IBAction)rate:(id)sender;
@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.movie.movieName;

    [self.detailsText setText:[self.movie movieDetails]];
    [self.detailsText setEditable:NO];
    [self.moviImageView setImage:[UIImage imageNamed:[self.movie movieImage]]];
    
    
    self.ratingView = [[RateView alloc] initWithFrameBig:CGRectMake(40, 328, 240, 40)];
    self.ratingView.alignment = RateViewAlignmentLeft;
    self.ratingView.editable = NO;
    self.ratingView.rate = [self.movie rating];
    [self.view addSubview:self.ratingView];
    
    self.alertRatingView = [[RateView alloc] initWithFrameBig:CGRectMake(20, 80, 240, 30)];
    self.alertRatingView.alignment = RateViewAlignmentLeft;
    self.alertRatingView.editable = YES;
    
    if (IS_HEIGHT_GTE_568) {
        CGRect frame = self.ratingView.frame;
        frame.origin.y += 88;
        [self.ratingView setFrame:frame];
    }
}

- (void)viewDidUnload {
    [self setDetailsText:nil];
    [self setMoviImageView:nil];
    [self setRatingButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)rate:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Ratings" message:@"Rate this film\n\n\n" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert addSubview:self.alertRatingView];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { 
    QBRScore *score = [QBRScore score];
    score.gameModeID = [self.movie gameModeID];
    score.value = self.alertRatingView.rate;
    [QBRatings createScore:score delegate:nil];
}

@end

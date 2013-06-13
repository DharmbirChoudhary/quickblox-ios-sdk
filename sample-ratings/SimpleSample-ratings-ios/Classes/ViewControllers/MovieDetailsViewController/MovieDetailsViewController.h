//
//  MoviDetailsViewController.h
//  SimpleSample-ratings-ios
//
//  Created by Ruslan on 9/11/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//
//
// This class shows movie's details - name, image & rate.
// It allows to rate this movie
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import "Movie.h"

@interface MovieDetailsViewController : UIViewController


@property (nonatomic, retain) Movie *movie;

@end

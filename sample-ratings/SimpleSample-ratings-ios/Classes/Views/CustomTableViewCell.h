//
//  CustomTableViewCell.h
//  SimpleSample-ratings-ios
//
//  Created by Ruslan on 9/11/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//
//
// This class presents custom table cell
//

#import <UIKit/UIKit.h>

@class  RateView;

@interface CustomTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet RateView *ratingView;
@property (retain, nonatomic) IBOutlet UILabel *movieName;
@property (retain, nonatomic) IBOutlet UIImageView *movieImageView;

@end

//
//  CustomTableViewCell.h
//  SimpleSample-custom-object-ios
//
//  Created by Ruslan on 9/14/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//
//
// This class presents table cell, that used for show note information 
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

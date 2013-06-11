//
//  CustomCell.h
//  SimpleSample-location_users-ios
//
//  Created by System Administrator on 6/11/13.
//
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *checkinMessage;
@property (retain, nonatomic) IBOutlet UIImageView *avatar;

@end

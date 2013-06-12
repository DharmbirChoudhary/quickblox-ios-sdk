//
//  CustomCell.h
//  SimpleSample-location_users-ios
//
//  Created by System Administrator on 6/11/13.
//
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *checkinMessage;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@end

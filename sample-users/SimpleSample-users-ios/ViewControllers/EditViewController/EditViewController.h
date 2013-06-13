//
//  EditViewController.h
//  SimpleSample-users-ios
//
//  Created by Alexey Voitenko on 13.03.12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//
//
// This class enables update QB user
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@class MainViewController;

@interface EditViewController : UIViewController <QBActionStatusDelegate>{
}
@property (nonatomic, weak) QBUUser* user;


@end

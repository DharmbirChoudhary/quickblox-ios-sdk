//
//  MainViewController.h
//  SimpleSample-users-ios
//
//  Created by Alexey Voitenko on 24.02.12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//
//
// This class shows how to work with QuickBlox Users module.
// It shows how to Sign In, Sign Out, Sign Up,
// how to use QuickBlox through social networks (Facebook, Twitter),
// retrieve all users, search users, edit user.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController {

}
@property (nonatomic, strong) QBUUser *currentUser;


@end

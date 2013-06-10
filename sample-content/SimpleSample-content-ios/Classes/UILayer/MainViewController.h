//
//  MainViewController.h
//  SimpleSample-Content
//
//  Created by kirill on 7/17/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//
//
// This class shows how to work with QuickBlox Content module.
// It shows how to organize user's gallery.
// It allows upload/download images to/from gallery.
//

#import <UIKit/UIKit.h>
#import "SplashViewController.h"

@interface MainViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate, QBActionStatusDelegate,UIGestureRecognizerDelegate>{
}

@end

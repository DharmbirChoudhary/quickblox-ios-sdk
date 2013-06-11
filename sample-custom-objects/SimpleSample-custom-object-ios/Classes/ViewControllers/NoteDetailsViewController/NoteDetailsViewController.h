//
//  NoteDetailsViewController.h
//  SimpleSample-custom-object-ios
//
//  Created by Ruslan on 9/14/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//
//
// This class shows particular note's details. It allow to add comments to note, delete note.
//

#import <UIKit/UIKit.h>

@interface NoteDetailsViewController : UIViewController

@property (strong, nonatomic) QBCOCustomObject *customObject;

- (void) reloadData;

@end

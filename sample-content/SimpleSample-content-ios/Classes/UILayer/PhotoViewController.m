//
//  PhotoController.m
//  SimpleSample-Content
//
//  Created by kirill on 7/17/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [self.photoDisplayer setImage:self.photoImage];
}

- (void)viewDidUnload {
    [self setPhotoDisplayer:nil];
    [super viewDidUnload];
}
@end

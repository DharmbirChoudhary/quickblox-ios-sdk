//
//  DataManager.m
//  SimpleSampleContent
//
//  Created by kirill on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"

static DataManager *instance = nil;

@implementation DataManager

+ (DataManager *)instance {    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)savePicture:(UIImage *)image {
    [self.images addObject:image];
}

- (NSMutableArray *)images {
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    
    return _images;
}

@end

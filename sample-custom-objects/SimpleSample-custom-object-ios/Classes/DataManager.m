//
//  DataManager.m
//  SimpleSample-custom-object-ios
//
//  Created by Ruslan on 9/14/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

static DataManager *dataManager = nil;

@synthesize notes;

+ (DataManager *)shared {    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[self alloc] init];
    });
    
    return dataManager;
}

- (NSMutableArray *)notes {
    if (!notes) {
        notes = [[NSMutableArray alloc] init];
    }
    
    return notes;
}

@end

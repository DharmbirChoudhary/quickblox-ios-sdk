//
//  DataManager.m
//  SimpleSample-location_users-ios
//
//  Created by Tatyana Akulova on 9/19/12.
//
//

#import "DataManager.h"

static DataManager *instance = nil;

@implementation DataManager

+ (DataManager *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
	
	return instance;
}


@end
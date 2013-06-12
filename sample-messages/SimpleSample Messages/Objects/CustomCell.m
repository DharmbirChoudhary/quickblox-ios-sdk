//
//  CustomCell.m
//  SimpleSample Messages
//
//  Created by System Administrator on 6/12/13.
//  Copyright (c) 2013 Injoit. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)dealloc {
    [_richContentButton release];
    [_pushText release];
    [super dealloc];
}
@end

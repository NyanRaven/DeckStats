//
//  StatsEntryObject.m
//  CoreData3
//
//  Created by Pascal on 20/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import "StatsEntryObject.h"

@implementation StatsEntryObject
-(id)init
{
    self= [super init];
    if (self) {
        _wins = 0;
        _losses = 0;
        _time = 0.0;
    }
    
    return self;
}

@end

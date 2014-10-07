//
//  StatsObject.m
//  CoreData3
//
//  Created by Pascal on 20/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import "StatsObject.h"

@implementation StatsObject
-(id)init
{
    self= [super init];
    if (self) {
        _stats = [[NSMutableArray alloc]init];
        for (int i=0; i<10; i++) {
            StatsEntryObject *newStatEntry = [[StatsEntryObject alloc]init];
            [_stats addObject:newStatEntry];
        }
    }
    
    return self;
}

-(void)addWinTo:(int)cla atTime:(float)timeFloat;
{
    ((StatsEntryObject *)[_stats objectAtIndex:cla]).wins += 1;
    ((StatsEntryObject *)[_stats objectAtIndex:cla]).time = (((StatsEntryObject *)[_stats objectAtIndex:cla]).time +timeFloat)/2;
    NSLog(@"wins:%i", ((StatsEntryObject *)[_stats objectAtIndex:cla]).wins);

}
-(void)addLossTo:(int)cla atTime:(float)timeFloat;
{
   ((StatsEntryObject *)[_stats objectAtIndex:cla]).losses += +1;
    ((StatsEntryObject *)[_stats objectAtIndex:cla]).time = (((StatsEntryObject *)[_stats objectAtIndex:cla]).time +timeFloat)/2;
    NSLog(@"losses:%i", ((StatsEntryObject *)[_stats objectAtIndex:cla]).losses);
}
@end

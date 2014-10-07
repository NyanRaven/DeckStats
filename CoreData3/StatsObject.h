//
//  StatsObject.h
//  CoreData3
//
//  Created by Pascal on 20/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatsEntryObject.h"

@interface StatsObject : NSObject

@property (nonatomic, retain) NSMutableArray *stats;
-(void)addWinTo:(int)cla atTime:(float)timeFloat;
-(void)addLossTo:(int)cla atTime:(float)timeFloat;
@end

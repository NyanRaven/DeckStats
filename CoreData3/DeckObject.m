//
//  DeckObject.m
//  CoreData3
//
//  Created by Pascal on 13/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import "DeckObject.h"

@implementation DeckObject


-(id)init
{
    self= [super init];
    if (self) {
        _cards = [[NSMutableArray alloc]init];
        
    }
    
    return self;
}
-(id)initWithDeck:(NSArray *)cardsArray withID:(NSNumber *)ID
{
    self = [super init];
    if (self) {
        _deckID = [[NSNumber alloc]init];
        _deckID = ID;
        _didCreateStatEntities = false;
        _needsStatObjectUpdate = true;
        _cards = [[NSArray alloc]init];
        _cards=cardsArray;
       // _isDouble = [[NSArray alloc]init];
       // _deckStats = [[StatsObject alloc]init];
        _name = @"test";
        _statsEntries = [[NSArray alloc]init];
        NSMutableArray *statsCache = [[NSMutableArray alloc]init];
        for (int i=0; i<10; i++) {
            StatsEntryObject *newStatEntry = [[StatsEntryObject alloc]init];
            [statsCache addObject:newStatEntry];
        }
        _statsEntries = statsCache;
    }
    return self;
}
- (id)initWithName:(NSString *)deckName ofClass:(NSString *)deckClass withID:(NSNumber *)ID
{
    self = [super init];
    if (self) {
        _deckID = [[NSNumber alloc]init];
        _deckID = ID;
        _didCreateStatEntities = false;
        _needsStatObjectUpdate = true;
        _name = deckName;
        _class = deckClass;
        _cardIDs = [[NSArray alloc]init];
        //_isDouble = [[NSArray alloc]init];
        //_deckStats = [[StatsObject alloc]init];
        _statsEntries = [[NSArray alloc]init];
        NSMutableArray *statsCache = [[NSMutableArray alloc]init];
        for (int i=0; i<10; i++) {
            StatsEntryObject *newStatEntry = [[StatsEntryObject alloc]init];
            [statsCache addObject:newStatEntry];
        }
        _statsEntries = statsCache;
    }
    return self;
}
-(void)addWinTo:(int)cla atTime:(float)timeFloat;
{
    ((StatsEntryObject *)[_statsEntries objectAtIndex:cla]).wins += 1;
    ((StatsEntryObject *)[_statsEntries objectAtIndex:cla]).time = (((StatsEntryObject *)[_statsEntries objectAtIndex:cla]).time +timeFloat)/2;
    NSLog(@"wins:%i", ((StatsEntryObject *)[_statsEntries objectAtIndex:cla]).wins);
    
}
-(void)addLossTo:(int)cla atTime:(float)timeFloat;
{
    ((StatsEntryObject *)[_statsEntries objectAtIndex:cla]).losses += +1;
    ((StatsEntryObject *)[_statsEntries objectAtIndex:cla]).time = (((StatsEntryObject *)[_statsEntries objectAtIndex:cla]).time +timeFloat)/2;
    NSLog(@"losses:%i", ((StatsEntryObject *)[_statsEntries objectAtIndex:cla]).losses);
}
-(void)setDoubleCardsArray:(NSMutableArray *)doubleCardsArray
{
   // _isDouble = doubleCardsArray;
}
-(void)setCardIDs:(NSArray *)deckArray
{
    _cardIDs = deckArray;
}
-(void)setDeckID:(NSNumber *)deckID
{
    _deckID = deckID;
}
-(id)getDeck
{
    return _cardIDs;
}
@end

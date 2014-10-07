//
//  DeckObject.h
//  CoreData3
//
//  Created by Pascal on 13/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatsEntryObject.h"

@interface DeckObject : NSObject
{
//@public NSArray *cardids;
  // NSArray *doubledCards;
}
@property(nonatomic) NSString *class,*name;
//@property(nonatomic) StatsObject *deckStats;
@property(nonatomic) NSArray *cards, *cardIDs, *statsEntries;
@property(nonatomic) BOOL didCreateStatEntities, needsStatObjectUpdate, mustBeDeleted;
@property(nonatomic, retain)NSNumber *deckID;
-(id)initWithDeck:(NSArray *)cardsArray withID:(NSNumber *)ID;
-(id)initWithName:(NSString *)deckName ofClass:(NSString *)deckClass withID:(NSNumber *)ID;
-(void)setCardIDs:(NSArray *)deckArray;
-(void)setDeckID:(NSNumber *)deckID;
-(void)setDoubleCardsArray:(NSArray *)doubleCardsArray;
-(void)addWinTo:(int)cla atTime:(float)timeFloat;
-(void)addLossTo:(int)cla atTime:(float)timeFloat;
-(id)getDeck;
@end

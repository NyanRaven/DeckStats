//
//  DeckCreatorViewController.h
//  CoreData3
//
//  Created by Pascal on 17/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDecksTableViewController.h"
#import "StatsViewController.h"
#import "DeckObject.h"
#import "CardObject.h"
#import "DeckCreatorTableViewCell.h"
#import "DSBarChart.h"

@interface DeckCreatorViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    NSString *classString;
    NSMutableArray *names, *costs, *deckCosts;
    NSMutableArray *Deck;
    int cardsInDeck;
}
@property (atomic, retain) DeckObject *createdDeck;
@property (atomic, retain) NSMutableArray *doubleCards, *barImages;
@property (nonatomic, retain)NSNumber *deckID;
@property (strong, nonatomic) IBOutlet UILabel *heroLabel;
@property (nonatomic) NSString *Hero;
@property (strong, nonatomic) IBOutlet UISegmentedControl *manaSelector;
@property IBOutlet UITableView *taView;
@property (strong, nonatomic) IBOutlet UIView *chartView;

@property (strong, nonatomic) IBOutlet UISwitch *classSwitch;
@property (strong, nonatomic) IBOutlet UIImageView *bar1;
@property (strong, nonatomic) IBOutlet UIImageView *bar2;
@property (strong, nonatomic) IBOutlet UIImageView *bar3;
@property (strong, nonatomic) IBOutlet UIImageView *bar4;
@property (strong, nonatomic) IBOutlet UIImageView *bar5;
@property (strong, nonatomic) IBOutlet UIImageView *bar6;
@property (strong, nonatomic) IBOutlet UIImageView *bar7;

- (IBAction)exitNow:(id)sender;
- (void)saveDeck;
-(IBAction)manaChanged:(id)sender;-(void)createDeckObjectsWithNames:(NSArray *)cardNames;
-(void)getCardsWithCost:(int)mana;
-(id)getCreatedDeck;
@end

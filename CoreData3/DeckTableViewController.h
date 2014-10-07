//
//  DeckTableViewController.h
//  CoreData3
//
//  Created by Pascal on 14/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeckObject.h"
#import "CardObject.h"
#import "CoreData3AppDelegate.h"
#import "DeckTableViewCell.h"
#import "StatsViewController.h"
#import "MyDecksTableViewController.h"

@interface DeckTableViewController : UITableViewController <UIActionSheetDelegate, UITextFieldDelegate>
{
    NSMutableArray *names;
    NSManagedObject *matches;
    int indexOfRenamedDeck;
}
@property(nonatomic)DeckObject *selectedDeck;
@property (strong, nonatomic) IBOutlet UIButton *uploadButtom;
@property(nonatomic)int cardsLeft;
@property(nonatomic)BOOL NotMyDecks;
@property(nonatomic)NSArray *cardlist;
@property(nonatomic)NSMutableArray *playedCards, *unplayedCards;
@property(nonatomic, retain)UIActionSheet *editPopUpMenu;
- (void)setDetailItem:(id)deck;
-(void)setNotMyDecks:(BOOL)isNotMyDecks;
-(IBAction)uploadDeckToParse:(id)sender;
- (IBAction)showDescription:(UILongPressGestureRecognizer *)sender;
-(void)sortCards:(NSMutableArray *)deck forAttribute:(NSString *)att;

@end

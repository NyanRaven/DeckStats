//
//  MyDecksTableViewController.h
//  CoreData3
//
//  Created by Pascal on 13/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeckObject.h"
#import "DeckTableViewController.h"
#import "DeckCreatorViewController.h"
#import "MyDecksTableViewCell.h"
#import "DisplayStatsViewController.h"
#import "FeaturedDecksTableViewController.h"
#import "HeroSelectViewController.h"
#import "StatsObject.h"
#import "StatsEntryObject.h"


@interface MyDecksTableViewController : UITableViewController <UIGestureRecognizerDelegate>
{
    int touchedAccessory;
    BOOL launched;
}

@property NSMutableArray *myDecks;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSMutableArray *assignedIDs;
@property (nonatomic, retain) NSNumber *longPressedDeckID;
@property (nonatomic) BOOL editingName;
- (IBAction)unwindToMyDecks:(UIStoryboardSegue *)unwindSegue;
- (IBAction)changeName:(UILongPressGestureRecognizer *)sender;
-(IBAction)returned:(UIStoryboardSegue *)segue;
+(NSArray *)createDeckWithIDs:(NSArray *)cardIDs;
-(void)updateTableView:(NSNumber *)index;
-(IBAction)unwindNeedsTableViewUpdate:(id)sender;
@end

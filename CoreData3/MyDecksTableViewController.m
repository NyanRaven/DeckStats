//
//  MyDecksTableViewController.m
//  CoreData3
//
//  Created by Pascal on 13/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import "MyDecksTableViewController.h"

@interface MyDecksTableViewController ()

@end

@implementation MyDecksTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    
    
    return self;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self createDeckObjectsFromCoreData:YES];
    [[self tableView]reloadData];
}

- (void)viewDidLoad
{
    [self deleteAllCardsFromCoreData];
    [self loadCardsFromJSON];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    _myDecks = [[NSMutableArray alloc]init];
    _assignedIDs = [[NSMutableArray alloc]init];
    /*
     NSArray *controlWarrior = [[NSArray alloc]initWithObjects:@420,@581,@581,@1372,@1372, nil];
     NSArray *assideck = [[NSArray alloc]initWithObjects:@581,@1372, nil];
     
     DeckObject *ctrlWarrior = [[DeckObject alloc]initWithName:@"Control Warrior" ofClass:@"Warrior"];
     [ctrlWarrior setDeckIDs:controlWarrior];
     
     
     StatsObject *warriorStats = [[StatsObject alloc]init];
     NSMutableArray *statsArray = [[NSMutableArray alloc]init];
     
     for(int i=0;i<9;i++)
     {
     StatsEntryObject *entry = [[StatsEntryObject alloc]init];
     entry.wins=10;
     entry.losses=5;
     [statsArray addObject:entry];
     
     }
     
     warriorStats.stats = statsArray;
     
     ctrlWarrior.deckStats = warriorStats;
     
     
     DeckObject *ctrlWarlock = [[DeckObject alloc]initWithName:@"Assideck" ofClass:@"Warlock"];
     [ctrlWarlock setDeckIDs:assideck];
     
     [_myDecks addObject:ctrlWarlock];
     [_myDecks addObject:ctrlWarrior];
     
     DeckObject *ctrl = [[DeckObject alloc]initWithName:@"neu" ofClass:@"warrior"];
     ctrl.cards = [MyDecksTableViewController createDeckWithIDs:controlWarrior];
     [_myDecks addObject:ctrl];
     
     */
    // all the decks in Core Data will be added
    //the Boolean states that
    [self createDeckObjectsFromCoreData:NO];
    NSLog(@"View loaded");
}
- (IBAction)unwindToMyDecks:(UIStoryboardSegue *)unwindSegue
{
    NSLog(@"canceled");
}

- (IBAction)changeName:(UILongPressGestureRecognizer *)sender {
    CGPoint pressPoint = [sender locationInView:[self tableView]];
    NSIndexPath *indexPath = [[self tableView] indexPathForRowAtPoint:pressPoint];
    _longPressedDeckID=[NSNumber numberWithInteger:indexPath.row] ;
    if (!_editingName) {
         _editingName = true;
         [self showRenamingDialog];
        
    }
   
}
-(void)showRenamingDialog
{
    UIAlertView* dialog = [[UIAlertView alloc]  initWithTitle:@"Rename" message:@"Enter new awesome name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    [dialog addButtonWithTitle:@"Save"];
    [dialog show];
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {  //Save
        UITextField *newNameTextField = [alertView textFieldAtIndex:0];
        ((DeckObject *)[_myDecks objectAtIndex:[_longPressedDeckID intValue]]).name = newNameTextField.text;
        
    }
    _editingName=false;
    [self.tableView reloadData];
}
-(NSNumber *)findUnassignedID
{
    NSNumber *testInt = [NSNumber numberWithInt:1];
    
    while ([testInt intValue]<100) {
       if (![_assignedIDs containsObject:testInt]) {
           [_assignedIDs addObject:testInt];
        return testInt;
       }
        testInt = [NSNumber numberWithInt:[testInt intValue]+1];
    }
    NSLog(@"too many decks");
    return nil;

}

    
-(IBAction)returned:(UIStoryboardSegue *)segue {
    DeckCreatorViewController *DCVC = segue.sourceViewController;
    
    DeckObject *returnedDeck = [[DeckObject alloc]init];
    returnedDeck = [DCVC getCreatedDeck];
    
    [_myDecks addObject:returnedDeck];
    [self.tableView reloadData];

}
-(void)createDeckObjectsFromCoreData:(BOOL)downloaded
{
    //decks from featured Decks need a special treatment cause they will egt their ID here
    
    CoreData3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"DecksDB" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *fetchedDeck in fetchedObjects) {
        
        if ([[fetchedDeck valueForKey:@"down"]boolValue]==downloaded) {
            //so that JUST Decks from featured deck (which are also saved to CoreData) are added
            //or JUST old Decks from CoreData
            if (downloaded) {
                [fetchedDeck setValue:[NSNumber numberWithBool:NO] forKey:@"down"];
            }
            NSString *newDeckString = [fetchedDeck valueForKey:@"cards"];
       
            DeckObject *newDeckObject = [[DeckObject alloc]initWithName:[fetchedDeck valueForKey:@"name"] ofClass:[fetchedDeck valueForKey:@"deckClass"]withID:[self findUnassignedID]];
        
            [fetchedDeck setValue:newDeckObject.deckID forKey:@"deckID"];
            
            newDeckObject.didCreateStatEntities = [[fetchedDeck valueForKey:@"createdStat"] boolValue];
        
            if (!newDeckObject.didCreateStatEntities) {
                [StatsViewController createStatEntities:newDeckObject];
                [fetchedDeck setValue:[NSNumber numberWithBool:YES] forKey:@"createdStat"];
            }
            NSArray *newDeckArray = [newDeckString componentsSeparatedByString:@","];
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSMutableArray *idArray = [[NSMutableArray alloc]init];
        
            for(NSString *st in newDeckArray)
            {
                NSNumber * cardID = [f numberFromString:st];
                [idArray addObject:cardID];
            }
            newDeckObject.cardIDs=idArray;
        
            newDeckObject.cards=[MyDecksTableViewController createDeckWithIDs:idArray];
        
        
            NSManagedObject *deckStat = [fetchedDeck valueForKey:@"stat"];
        
            NSString *winsCD = [deckStat valueForKey:@"wins"];
            NSString *lossesCD = [deckStat valueForKey:@"losses"];
        
            NSArray *wins = [[NSArray alloc]init];
            wins = [winsCD componentsSeparatedByString:@","];
        
            NSArray *losses = [[NSArray alloc]init];
            losses = [lossesCD componentsSeparatedByString:@","];
            
            NSMutableArray *statCache = [[NSMutableArray alloc]initWithArray:newDeckObject.statsEntries];
            for (int i=0; i<9; i++) {
                ((StatsEntryObject *)[newDeckObject.statsEntries objectAtIndex:i]).wins= [[wins objectAtIndex:i] intValue];
               ((StatsEntryObject *)[newDeckObject.statsEntries objectAtIndex:i]).losses=[[losses objectAtIndex:i] intValue];
                NSLog(@"win at %i: %i",i,[[wins objectAtIndex:i] intValue]);
            }
           
            newDeckObject.statsEntries = statCache;
            
            [_myDecks addObject:newDeckObject];
            }
        
        }

}
-(void)loadCardsFromJSON
{
    
    CoreData3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    //check whether or not card already got imported
    if (objects.count<10) {

    
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"cards" ofType:@"json"];
    NSArray* Cards = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]options:kNilOptions error:&err];
    
    NSLog(@"cards to save %lu",(unsigned long)Cards.count);
    for(NSDictionary *item in Cards) {
        
        //BOOL coll = [[item valueForKey:@"collectible"] boolValue];
        if ( [[item valueForKey:@"collectible"] boolValue] ) {

        if ([[item valueForKey:@"type"] isEqualToString:@"minion"]) {
            
            NSManagedObject *newMinion;
            newMinion = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
            [newMinion setValue: [item valueForKey:@"name"] forKey:@"name"];
            [newMinion setValue:[item valueForKey:@"description"] forKey:@"text"];
            [newMinion setValue: [item valueForKey:@"attack"]  forKey:@"atk"];
            [newMinion setValue: [item valueForKey:@"mana"]  forKey:@"cost"];
            [newMinion setValue: [item valueForKey:@"health"] forKey:@"def"];
            [newMinion setValue: [item valueForKey:@"type"] forKey:@"kind"];
            [newMinion setValue: [item valueForKey:@"id"] forKey:@"id"];
            [newMinion setValue:[item valueForKey:@"class"] forKey:@"hero"];
            [newMinion setValue: [item valueForKey:@"set"] forKey:@"rarity"];
            NSError *error;
            [context save:&error];
            
        }
        if ([[item valueForKey:@"type"]isEqualToString:@"spell"]) {
            NSManagedObject *newSpell;
            newSpell = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
            [newSpell setValue: [item valueForKey:@"name"] forKey:@"name"];
            [newSpell setValue:[item valueForKey:@"description"] forKey:@"text"];
            [newSpell setValue: [item valueForKey:@"mana"]  forKey:@"cost"];
            [newSpell setValue: [item valueForKey:@"type"] forKey:@"kind"];
            [newSpell setValue: [item valueForKey:@"id"] forKey:@"id"];
            [newSpell setValue: [item valueForKey:@"set"] forKey:@"rarity"];
            [newSpell setValue:[item valueForKey:@"class"] forKey:@"hero"];
            NSError *error;
            [context save:&error];
        }
        
        if ([[item valueForKey:@"type"]isEqualToString:@"weapon"]) {
            NSManagedObject *newWeapon;
            newWeapon = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
            [newWeapon setValue: [item valueForKey:@"name"] forKey:@"name"];
            [newWeapon setValue:[item valueForKey:@"description"] forKey:@"text"];
            [newWeapon setValue: [item valueForKey:@"type"] forKey:@"kind"];
            [newWeapon setValue: [item valueForKey:@"set"] forKey:@"rarity"];
            [newWeapon setValue: [item valueForKey:@"id"] forKey:@"id"];
            [newWeapon setValue: [item valueForKey:@"attack"]  forKey:@"atk"];
            [newWeapon setValue: [item valueForKey:@"mana"]  forKey:@"cost"];
            [newWeapon setValue: [item valueForKey:@"health"] forKey:@"def"];
            [newWeapon setValue:[item valueForKey:@"class"] forKey:@"hero"];
            NSError *error;
            [context save:&error];
        }
        
          }
    }
    }
}
- (void)deleteAllCardsFromCoreData
{
    CoreData3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
   
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    [request setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    
    NSArray *cardsToDelete = [context executeFetchRequest:request error:&error];
    
    for (NSManagedObject *obj in cardsToDelete){
        [context deleteObject:obj];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(NSArray *)createDeckWithIDs:(NSArray *)cardIDs
{
    NSMutableArray *doubleCards = [[NSMutableArray alloc]init];
    NSMutableArray *deleteCacheArray = [[NSMutableArray alloc]initWithArray:cardIDs];
    NSMutableArray *cacheDeckArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<cardIDs.count-1; i++) {
        if ([[cardIDs objectAtIndex:i]isEqualToNumber:[cardIDs objectAtIndex:i+1]]) {
            [doubleCards addObject:[cardIDs objectAtIndex:i]];
            [deleteCacheArray removeObjectAtIndex:i];
            cardIDs = deleteCacheArray;
        }
        
    }
    CoreData3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    for (int i=0; i<cardIDs.count; i++) {
        CardObject *newCard = [[CardObject alloc]init];
        int d = [[cardIDs objectAtIndex:i] intValue];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(id = %i)", d];
        [request setPredicate:pred];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request
                                                  error:&error];
        
        if ([objects count] == 0) {
            NSLog(@"no card found");
            
        } else {
            newCard.cardName = [objects[0] valueForKey:@"name"];
            newCard.description = [objects[0]valueForKey:@"text"];
            newCard.cardID = [[objects[0] valueForKey:@"id"] integerValue];
            newCard.mana =  [[objects[0] valueForKey:@"cost"] integerValue];
            newCard.kind = [objects[0]valueForKey:@"kind"];
            newCard.atk = [[objects[0]valueForKey:@"atk"]integerValue];
            newCard.def = [[objects[0]valueForKey:@"def"]integerValue];
            //newCard.quality = [objects[0]valueForKey:@"quality"];
            if ([doubleCards containsObject:[cardIDs objectAtIndex:i]]) {
                newCard.isDouble = true;
            }
            
            [cacheDeckArray addObject:newCard];
            
        }
        
    }
    
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mana" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [cacheDeckArray sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return sortedArray;
}
-(void)deleteCoreDataDeckWithID:(NSNumber *)deckToDeleteID
{
    
    CoreData3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"DecksDB" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(deckID = %i)", [deckToDeleteID intValue]];
    [fetchRequest setPredicate:pred];
    
    
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"delete deck %i. Found:%lu",[deckToDeleteID intValue],(unsigned long)fetchedObjects.count);
    
    for (NSManagedObject *fetchedDeck in fetchedObjects)
    {
        [context deleteObject:fetchedDeck];
    }
    
    
    NSEntityDescription *entityStat = [NSEntityDescription
                                   entityForName:@"StatsDB" inManagedObjectContext:context];
    [fetchRequest setEntity:entityStat];
    
    NSPredicate *predStat = [NSPredicate predicateWithFormat:@"(deckID = %i)", [deckToDeleteID intValue]];
    [fetchRequest setPredicate:predStat];
    
    NSArray *fetchedObjectsStat = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *fetchedDeck in fetchedObjectsStat)
    {
        [context deleteObject:fetchedDeck];
    }

    NSError *newError;
    [context save:&newError];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _myDecks.count;
}
-(void)updateTableView:(NSNumber *)index
{
    //NSArray *indexes = [[NSArray alloc]initWithObjects:index, nil];
    //[[self tableView] reloadRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationFade];
    [[self tableView]reloadData];
    NSLog(@"table updated");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyDecksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Deck" forIndexPath:indexPath];
    
    DeckObject *deck = [_myDecks objectAtIndex:indexPath.row];
    NSString *bgImageName = [NSString stringWithFormat:@"%@Deck.png",deck.class ];
   
    cell.deckName.text = [NSString stringWithFormat:@"%@",deck.name];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:bgImageName] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0 ] ];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return cell;
   
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    touchedAccessory = (int)indexPath.row ;
    [self performSegueWithIdentifier:@"showStats" sender:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self deleteCoreDataDeckWithID:((DeckObject *)[_myDecks objectAtIndex:indexPath.row]).deckID];
        [_myDecks removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
-(IBAction)unwindNeedsTableViewUpdate:(id)sender
{
    [[self tableView]reloadData];
}


#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showDeck"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DeckObject *deck = [_myDecks objectAtIndex:indexPath.row];
        DeckTableViewController *detail = [segue destinationViewController];
        [detail setDetailItem:deck ];
        
    }
    if ([[segue identifier] isEqualToString:@"showStats"]) {
        NSArray *st = ((DeckObject *)[_myDecks objectAtIndex:touchedAccessory]).statsEntries;
        DisplayStatsViewController *DSVC = [segue destinationViewController];
        [DSVC setDetailItem:st];
        [DSVC setDeckID:((DeckObject *)[_myDecks objectAtIndex:touchedAccessory]).deckID];
        
    }
    if ([[segue identifier] isEqualToString:@"showDeckCreator"]) {
        HeroSelectViewController *HSVC = [segue destinationViewController];
        HSVC.deckID = [self findUnassignedID];
    }
}


@end

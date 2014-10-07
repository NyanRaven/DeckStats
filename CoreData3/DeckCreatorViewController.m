//
//  DeckCreatorViewController.m
//  CoreData3
//
//  Created by Pascal on 17/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import "DeckCreatorViewController.h"

@interface DeckCreatorViewController ()

@end

@implementation DeckCreatorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self getCardsWithCost:1];
        [_taView reloadData];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"läuft noch!");
    // Do any additional setup after loading the view.
    names = [[NSMutableArray alloc]init];
    costs = [[NSMutableArray alloc]init];
    classString = [[NSString alloc]init];
    Deck = [[NSMutableArray alloc]init];
    _doubleCards = [[NSMutableArray alloc]init];
    
    deckCosts = [[NSMutableArray alloc]init];
    cardsInDeck =  0;
    [_manaSelector setSelectedSegmentIndex:1];
    
    classString = _Hero;
    _heroLabel.text = classString;
    
    _createdDeck = [[DeckObject alloc]initWithName:[NSString stringWithFormat:@"new%@",classString] ofClass:classString withID:_deckID];
    [self getCardsWithCost:1];
    
    
    for (int i=0; i<8; i++) {
        NSNumber *cost = [[NSNumber alloc]initWithInt:0];
        [deckCosts addObject:cost];
    }
    [self updateChart];
    
}
-(void)createDeckObjectsWithNames:(NSArray *)cardNames
{
    
    NSMutableArray *cacheDeckArray = [[NSMutableArray alloc]init];
    NSMutableArray *cardIDsArray = [[NSMutableArray alloc]init];
    
    CoreData3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    for (int i=0; i<cardNames.count; i++) {
        CardObject *newCard = [[CardObject alloc]init];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name = %@)", ((CardObject *)[cardNames objectAtIndex:i]).cardName];
        [request setPredicate:pred];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        if ([objects count] == 0) {
            NSLog(@"no card found");
            
        } else {
            newCard.cardName = [objects[0] valueForKey:@"name"];
            //newCard.description = [objects[0]valueForKey:@"text"];
            newCard.cardID = [[objects[0] valueForKey:@"id"] integerValue];
            newCard.mana =  [[objects[0] valueForKey:@"cost"] integerValue];
            newCard.kind = [objects[0]valueForKey:@"kind"];
            newCard.atk = [[objects[0]valueForKey:@"atk"]integerValue];
            newCard.def = [[objects[0]valueForKey:@"def"]integerValue];
            if ([_doubleCards containsObject:[cardNames objectAtIndex:i]]) {
                newCard.isDouble = true;
                [cardIDsArray addObject:[NSNumber numberWithInteger:newCard.cardID]];
            }
            [cardIDsArray addObject:[NSNumber numberWithInteger:newCard.cardID]];
            [cacheDeckArray addObject:newCard];
            
        }
        
    }
    
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mana" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [cacheDeckArray sortedArrayUsingDescriptors:sortDescriptors];
    
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
     [cardIDsArray sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    _createdDeck.cardIDs = cardIDsArray;
    _createdDeck.cards = sortedArray;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (IBAction)saveDeck:(id)sender {
    NSMutableArray *deckToSave = [[NSMutableArray alloc]init];
    
    CoreData3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    for (int i=0; i<Deck.count; i++) {
        NSString *cardName = Deck[i];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name = %@)", cardName];
        [request setPredicate:pred];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request
                                                  error:&error];
        
        if ([objects count] == 0) {
            NSLog(@"no card found");
            
        } else {
            [deckToSave addObject: [objects[0] valueForKey:@"id"]];
           // NSLog(@"added card ID: %@",deckToSave.lastObject);
        }
        
    }
     [self createDeckObjectsWithNames:deckToSave];
    
}
*/
- (IBAction)manaChanged:(id)sender {
    [self getCardsWithCost:(int)_manaSelector.selectedSegmentIndex];
}

- (IBAction)classSwitched:(id)sender {
    [self getCardsWithCost:(int)_manaSelector.selectedSegmentIndex];
    
}

-(void)getCardsWithCost:(int)mana
{
    [names removeAllObjects];
    [costs removeAllObjects];
    
    CoreData3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
        int d = (int)_manaSelector.selectedSegmentIndex;
    
        NSPredicate *pred = [NSPredicate predicateWithFormat: @"(cost = %i)", d];
    if (d>6) {
        pred = [NSPredicate predicateWithFormat:@"(cost >= %i)",d];
    }
        [request setPredicate:pred];
        NSError *error;
        NSManagedObject *matches = nil;
        NSArray *objects = [context executeFetchRequest:request
                                                  error:&error];
    
    //matches=objects[0];
    for (int i=0; i<objects.count; i++)
    {
        matches=objects[i];
        NSString *claNam = [[NSString alloc]init];
        claNam = [matches valueForKey:@"hero"];
        NSString *switchString = [[NSString alloc]init];
        if (_classSwitch.isOn) {
            switchString = classString;
        }else switchString = @"neutral";
        
        if ([claNam isEqualToString:switchString]) {
            CardObject *nCard = [[CardObject alloc]init];
            nCard.cardName = [matches valueForKey:@"name"];
            nCard.mana = [[matches valueForKey:@"cost"] intValue];
            [names addObject:nCard];
        }
    }
   
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"cardName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSMutableArray *sorted = [[NSMutableArray alloc]initWithArray:[names sortedArrayUsingDescriptors:@[sortDescriptor]]];
    names = sorted;
    
    [_taView reloadData];
    
}
-(id)getCreatedDeck
{
  /* thats what MyDecks uses to fetch the new Deck*/
    
    return _createdDeck;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return @"Cards in Deck";
    }else return @"";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (section==0)? names.count: Deck.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     DeckCreatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Card" forIndexPath:indexPath];
    cell.isDoubleIcon.hidden=YES;
    // Configure the cell...
    if (indexPath.section==0) {

        cell.cardLabel.text = ((CardObject *)[names objectAtIndex:indexPath.row]).cardName;
        
    }else
    {
        cell.cardLabel.text = ((CardObject *)[Deck objectAtIndex:indexPath.row]).cardName ;
        if ([_doubleCards containsObject:[Deck objectAtIndex:indexPath.row]]) {
            cell.isDoubleIcon.hidden=NO;
        }
    }
    
    
    return cell;
}

/*
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}
 */
-(void)addCard:(CardObject *)selCard toArray:(NSMutableArray *)array andIndexPath:(NSIndexPath *)path shallAdd:(BOOL)add
{
    // is needed to add the selected Card to either doubleCards or to the Deck
    
    NSInteger c = selCard.mana ;
    if (c >5) {
        c = 6;
    }

    
    NSNumber *costCache = [deckCosts objectAtIndex:c];
    int val = [costCache intValue];
    
    if (add) {
        costCache = [NSNumber numberWithInt:val+1];
        [array addObject:selCard];
    }else {
        costCache = [NSNumber numberWithInt:val-1];
        [array removeObject:selCard];
    }
    
    [deckCosts replaceObjectAtIndex:c withObject:costCache];
    float scale = costCache.intValue/20.0;
    
    UIImageView *selImage = [_barImages objectAtIndex:c];
    selImage.transform = CGAffineTransformMakeScale(1, scale);
    if (scale>0.5) {
        selImage.hidden=YES;
    }else selImage.hidden=NO;
   
    [self updateChart];
}
-(void)updateChart
{
    DSBarChart *costChart = [[DSBarChart alloc]initWithFrame:_chartView.bounds color:[UIColor blueColor] references:deckCosts andValues:deckCosts];
    [_chartView addSubview:costChart];
}
- (IBAction)exitNow:(id)sender {
    [self dismissViewControllerAnimated:YES completion: ^{
        NSLog(@"dismissed");
    }];
}

-(void)saveDeck
{
    
    //NSManagedObjectContext *context = [self managedObjectContext];
    
    
    [self createDeckObjectsWithNames:Deck];
    
    
    CoreData3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSError *error;
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newDeck;
    newDeck = [NSEntityDescription insertNewObjectForEntityForName:@"DecksDB" inManagedObjectContext:context];

    NSString *createdDeckString = [_createdDeck.cardIDs componentsJoinedByString:@","];
    [newDeck setValue: createdDeckString forKeyPath:@"cards"];
    [newDeck setValue:_createdDeck.name forKeyPath:@"name"];
    [newDeck setValue:_createdDeck.class forKeyPath:@"deckClass"];
    [newDeck setValue:_createdDeck.deckID forKeyPath:@"deckID"];
    [newDeck setValue:[NSNumber numberWithBool:YES] forKey:@"createdStat"];
    [newDeck setValue:[NSNumber numberWithBool:NO] forKey:@"down"];
    [context save:&error];
    
    
    [StatsViewController createStatEntities:_createdDeck];
    
    _createdDeck.didCreateStatEntities=true;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CardObject *selectedCard;
   
    if (cardsInDeck<=30&&indexPath.section==0) {
        selectedCard = [names objectAtIndex:indexPath.row];
        if ([Deck containsObject:selectedCard]) {
            if ([_doubleCards containsObject:selectedCard]) {
                NSLog(@">2 doublecards");
                cardsInDeck--;
            }else [self addCard:selectedCard toArray:_doubleCards andIndexPath:indexPath shallAdd:YES];
        }else [self addCard:selectedCard toArray:Deck andIndexPath:indexPath shallAdd:YES];
        cardsInDeck++;
    }
    
    if (indexPath.section==1) {

        selectedCard = [Deck objectAtIndex:indexPath.row];
        if ([_doubleCards containsObject: selectedCard]) {
            [self addCard:selectedCard toArray:_doubleCards andIndexPath:indexPath shallAdd:NO];
            NSLog(@"double double");
        }else
        {
            [self addCard:selectedCard toArray:Deck andIndexPath:indexPath shallAdd:NO];
            NSLog(@"delete");
        }
        cardsInDeck--;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (cardsInDeck==30) {
        //[self saveDeck:self];
        NSLog(@"saved");
        [self saveDeck];
        [self showFinishedDeckDialog];
        
    }
    
    [_taView reloadData];

}
-(void)showFinishedDeckDialog
{
    UIAlertView* dialog = [[UIAlertView alloc]  initWithTitle:@"Done" message:@"You have created an awesome deck! Now hit save." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    dialog.alertViewStyle = UIAlertViewStyleDefault;
    //[dialog addButtonWithTitle:@"Ok"];
    [dialog show];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

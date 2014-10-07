//
//  DeckTableViewController.m
//  CoreData3
//
//  Created by Pascal on 14/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import "DeckTableViewController.h"

@interface DeckTableViewController ()

@end

@implementation DeckTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.e
    if (_NotMyDecks) {
        _uploadButtom.hidden=true;
    }
    _cardlist = [_selectedDeck getDeck];
    names = [[NSMutableArray alloc]init];
    _playedCards = [[NSMutableArray alloc]init];
    _unplayedCards = [[NSMutableArray alloc]initWithArray:_selectedDeck.cards];
    _cardsLeft=30;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setDetailItem:(id)deck
{
    if (_selectedDeck != deck) {
        _selectedDeck = [[DeckObject alloc]init];
        _selectedDeck = deck;
        }
    NSLog(@"%lu cards in deck",(unsigned long)_selectedDeck.cards.count);
    
}
- (IBAction)showDescription:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
  
        CGPoint pressPoint = [sender locationInView:[self tableView]];
        NSIndexPath *indexPath = [[self tableView] indexPathForRowAtPoint:pressPoint];
        
    
        UIAlertView *desc = [[UIAlertView alloc]init];
        [desc addButtonWithTitle:@"Got it"];
        desc.alertViewStyle= UIAlertViewStyleDefault;
       
        
        CardObject *longTouchedCard;
        if (indexPath.section == 0) {
                longTouchedCard = ((CardObject *)[_unplayedCards objectAtIndex:indexPath.row]);
        }else   longTouchedCard = ((CardObject *)[_playedCards objectAtIndex:indexPath.row]);
        
        if ([longTouchedCard.kind isEqualToString:@"weapon"]||[longTouchedCard.kind isEqualToString:@"minion"]) {
            desc.title = [NSString stringWithFormat:@"A:%li \t D:%li \n %@",(long)longTouchedCard.atk, (long)longTouchedCard.def, longTouchedCard.description ];
        }else desc.title = longTouchedCard.description;
        [desc show];
        //NSLog(@"kind: %@",longTouchedCard.kind);
    }
}
#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [NSString stringWithFormat:@"Cards (%i)",_cardsLeft ];
    }else return @"played Cards";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return ((section == 0)? _unplayedCards.count : _playedCards.count);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeckTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Entry" forIndexPath:indexPath];
    
    CardObject *card = [[CardObject alloc]init];
    
    cell.isDoubleIcon.hidden=NO;
    if (indexPath.section == 0) {
        card = [_unplayedCards objectAtIndex:indexPath.row];
        cell.cardNameLabel.text = card.cardName;
    }else
    {
        card = [_playedCards objectAtIndex:indexPath.row];
        cell.cardNameLabel.text = card.cardName;
    }
    
    
    if (!card.isDouble) {
        cell.isDoubleIcon.hidden=YES;
    }
   
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CardObject *touchedCard= [[CardObject alloc]init];
    

    if (indexPath.section == 0) {
        touchedCard= [_unplayedCards objectAtIndex:indexPath.row];
        
        if (touchedCard.isDouble) {
            touchedCard.isDouble = false;
            [_playedCards addObject:touchedCard];
        }else
        {
            if (![self cardName:touchedCard.cardName isContainedIn:_playedCards]) {
                //[_playedCards addObject:touchedCard];
                [self addCard:touchedCard ToArray:_playedCards];
            }
            [_unplayedCards removeObjectAtIndex:indexPath.row];
        }
        _cardsLeft--;
        
    }else
    {
        if (_unplayedCards.count>0) {
        touchedCard= [_playedCards objectAtIndex:indexPath.row];
        
        if (touchedCard.isDouble) {
            touchedCard.isDouble = false;
            [_unplayedCards addObject:touchedCard];
        }else
        {
            
            if (![self cardName:touchedCard.cardName isContainedIn:_unplayedCards]) {
               // [_unplayedCards addObject:touchedCard];
                [self addCard:touchedCard ToArray:_unplayedCards];
            }
            
            [_playedCards removeObjectAtIndex:indexPath.row];
        }
        _cardsLeft++;
       }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
    
    
}
-(BOOL)cardName:(NSString *)name isContainedIn:(NSMutableArray *)array
{
        for(CardObject *doubleCard in array)
    {
        if ([doubleCard.cardName isEqualToString:name]) {
            doubleCard.isDouble=true;
            return true;
        }
        
    }
    return false;
    
}
-(void)addCard:(CardObject *)card ToArray:(NSMutableArray *)array
{
    int i=0;
    for(CardObject *cardFromArray in array)
    {
        if (card.mana<=cardFromArray.mana) {
            [array insertObject:card atIndex:i];
            break;
        }
        i++;
        //[array addObject:card];
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

- (IBAction)unwindToDeckTableViewController:(UIStoryboardSegue *)unwindSegue
{
    
}
-(IBAction)uploadDeckToParse:(id)sender
{
    PFObject *deckToSave = [PFObject objectWithClassName:@"Deck"];
    deckToSave[@"cards"]=[_selectedDeck cardIDs] ;
    deckToSave[@"cla"]=_selectedDeck.class;
    deckToSave[@"deckName"]=_selectedDeck.name;
    [deckToSave saveInBackground];
}
/*
- (IBAction)showPopUp:(id)sender {
    _editPopUpMenu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:@"upload",@"rename", nil];
    
    [_editPopUpMenu showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == _editPopUpMenu) {
        
        switch (buttonIndex) {
                
            case 0:
                //delete the Deck
                _selectedDeck.mustBeDeleted=true;
                break;
                
            case 1:
                //upload
                [self uploadDeckToParse];
                break;
                
            case 2:
                //rename
                [self showRenamingDialog];
                break;
                
            default:
                break;
        }
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
    NSLog(@"Button Index =%i",buttonIndex);
    if (buttonIndex == 1) {  //Save
        UITextField *newNameTextField = [alertView textFieldAtIndex:0];
        _selectedDeck.name = newNameTextField.text;
        
    }
}
 */
- (IBAction)saveStats:(UIStoryboardSegue *)unwindSegue
{
    NSLog(@"Stats Saved");
}
-(void)viewWillDisappear:(BOOL)animated
{
    /*
    for (CardObject *card in _playedCards)
  {
      if (![self cardName:card.cardName isContainedIn:_unplayedCards])
      {
           [_unplayedCards addObject:card];
          //[self addCard:card ToArray:_unplayedCards];
      }
      
     
     
  }
    
    
    [self sortCards:_unplayedCards forAttribute:@"mana"];
    
     */
    [_playedCards removeAllObjects];    _unplayedCards = [[NSMutableArray alloc]initWithArray:_selectedDeck.cards];
    _cardsLeft=30;
    [[self tableView]reloadData];
}
-(void)sortCards:(NSMutableArray *)deck forAttribute:(NSString *)att
{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:att ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [deck sortedArrayUsingDescriptors:sortDescriptors];
    
    NSMutableArray *sort = [[NSMutableArray alloc]initWithArray:sortedArray];
    deck = sort;
 
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showStatsCreator"])
    {
        StatsViewController *detail = [segue destinationViewController];
        [detail setDetailItem:_selectedDeck ];
        NSLog(@"stat obj prepared");
        _cardsLeft=30;
    }
}


@end

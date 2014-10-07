//
//  FeaturedDeckCardViewController.m
//  CoreData3
//
//  Created by Pascal on 06/05/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import "FeaturedDeckCardViewController.h"

@interface FeaturedDeckCardViewController ()

@end

@implementation FeaturedDeckCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _deckCosts = [[NSMutableArray alloc]init];
    
    
    for (int i=0; i<8; i++) {
        NSNumber *num = [NSNumber numberWithInt:0];
        [_deckCosts addObject:num];
    }
    for(CardObject *card in _selectedDeck.cards)
    {
        int mana = (int)card.mana;
        if (mana>7) {
            mana=7;
        }
        int cost = ((NSNumber *)[_deckCosts objectAtIndex:mana]).intValue;
        NSNumber *incCost = [NSNumber numberWithInt:cost+1];
        [_deckCosts replaceObjectAtIndex:mana withObject:incCost];
    }
    
    DSBarChart *costChart = [[DSBarChart alloc]initWithFrame:_chartView.bounds color:[UIColor blueColor] references:_deckCosts andValues:_deckCosts];
    [_chartView addSubview:costChart];
    
    
    
}
- (void)setDetailItem:(id)newBO
{
    if (_selectedDeck != newBO) {
        _selectedDeck = [[DeckObject alloc]init];
        _selectedDeck = newBO;
    }
   
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _selectedDeck.cards.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    featuredTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Card" forIndexPath:indexPath];
    
    // Configure the cell...
    CardObject *card = [_selectedDeck.cards objectAtIndex:indexPath.row];
    
    cell.isDoubleIcon.hidden = true;
    cell.cardNameLabel.text = card.cardName;
    if (card.isDouble) {
        cell.isDoubleIcon.hidden = false;
    }
    return cell;
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

- (IBAction)download:(id)sender {
    CoreData3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSError *error;
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newDeck;
    newDeck = [NSEntityDescription insertNewObjectForEntityForName:@"DecksDB" inManagedObjectContext:context];
    
    NSString *createdDeckString = [_selectedDeck.cardIDs componentsJoinedByString:@","];
    [newDeck setValue: createdDeckString forKeyPath:@"cards"];
    [newDeck setValue:_selectedDeck.name forKeyPath:@"name"];
    [newDeck setValue:_selectedDeck.class forKeyPath:@"deckClass"];
    [newDeck setValue:[NSNumber numberWithInt:0] forKeyPath:@"deckID"];
    [newDeck setValue:[NSNumber numberWithBool:NO] forKey:@"createdStat"];
    [newDeck setValue:[NSNumber numberWithBool:YES] forKey:@"down"];
    [context save:&error];
    
    //[StatsViewController createStatEntities:_selectedDeck];
    //I dont know the right ID cause this gets set later
}
@end

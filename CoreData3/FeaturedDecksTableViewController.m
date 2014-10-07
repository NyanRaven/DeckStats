//
//  FeaturedDecksTableViewController.m
//  CoreData3
//
//  Created by Pascal on 01/05/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import "FeaturedDecksTableViewController.h"

@interface FeaturedDecksTableViewController ()

@end

@implementation FeaturedDecksTableViewController

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
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _featuredDecks = [[NSMutableArray alloc]init];
    _assignedIDs = [[NSMutableArray alloc]init];
    
    
    [self loadDecksFromParse];
    
}
-(void)loadDecksFromParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"Deck"];
    
    //[query whereKey:@"class" equalTo:@"warrior"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu BOs.", (unsigned long)objects.count);
            // Do something with the found objects
            NSNumber *idCounter = [[NSNumber alloc]initWithInt:0];
            for (PFObject *object in objects) {
                
                
                DeckObject *newDeck = [[DeckObject alloc]initWithName:object[@"deckName"] ofClass:object[@"cla"] withID:0] ;
                if (((NSArray*)object[@"cards"]).count > 5) {
                    NSArray *cardIDs = [[NSArray alloc]initWithArray:object[@"cards"]];
                    newDeck.cards = [MyDecksTableViewController createDeckWithIDs:cardIDs];
                    newDeck.cardIDs = cardIDs;
                    [_featuredDecks addObject:newDeck];
                    idCounter = [NSNumber numberWithInt:[idCounter intValue]+1];
                }else NSLog(@"no valid Deck");
                
                
                
            }
        }
        //sort
        [self sortFeaturedDecksTo:@"class"];
        [self.tableView reloadData];
    }];
}
-(void)sortFeaturedDecksTo:(NSString *)attribute
{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [_featuredDecks sortedArrayUsingDescriptors:sortDescriptors];
    
    _featuredDecks = [[NSMutableArray alloc]initWithArray:sortedArray];
    
}

-(NSNumber *)findUnassignedID
{
    NSNumber *testInt = [NSNumber numberWithInt:0];
    
    while (true) {
        if (![_assignedIDs containsObject:testInt]) {
            [_assignedIDs addObject:testInt];
            return testInt;
        }
        testInt = [NSNumber numberWithInt:[testInt intValue]+1];
    }
    
    return nil;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return _featuredDecks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyDecksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Deck" forIndexPath:indexPath];
    
    DeckObject *deck = [_featuredDecks objectAtIndex:indexPath.row];
    
    NSString *bgImageName = [NSString stringWithFormat:@"%@Deck.png",deck.class ];
    
    // Configure the cell...
    
    cell.featLabel.text = deck.name;
    //cell.deckName.text = deck.name;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:bgImageName] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0 ] ];
    //cell.backgroundImage.image = [UIImage imageNamed:bgImageName];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    return cell;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showFeaturedDeck"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DeckObject *deck = [_featuredDecks objectAtIndex:indexPath.row];
        FeaturedDeckCardViewController  *detail = [segue destinationViewController];
        [detail setDetailItem:deck ];
        
        
    }
}


@end

//
//  DisplayStatsViewController.m
//  CoreData3
//
//  Created by Pascal on 20/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import "DisplayStatsViewController.h"

@interface DisplayStatsViewController ()

@end

@implementation DisplayStatsViewController

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
    
    NSLog(@"stat count: %lu",(unsigned long)_currentStat.count);
    [self readStatEntries];
}
-(void)readStatEntries
{
    int totalWins=0;
    int totalLosses=0;
    _totalGames = 0 ;
    for (StatsEntryObject *st in _currentStat)
    {
        totalWins +=   st.wins;
        totalLosses += st.losses;
    }
    _totalGames = totalLosses + totalWins;
    _totalWinsLabel.text = [NSString stringWithFormat:@"%i",totalWins];
    _winPercLabel.text = [NSString stringWithFormat:@"%.2f",totalWins/(float)_totalGames *100];
   
   }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [_taView reloadData];
}
-(IBAction)resetStats:(id)sender
{
    //NO WAY TO GET THE NECESSARY DECK ID
    //Yes there is, probably..
    
    CoreData3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityStat = [NSEntityDescription
                                       entityForName:@"DecksDB" inManagedObjectContext:context];
    [fetchRequest setEntity:entityStat];
    
    NSPredicate *predStat = [NSPredicate predicateWithFormat:@"(deckID = %i)", [_deckID intValue]];
    [fetchRequest setPredicate:predStat];
    
    NSArray *fetchedObjectsStat = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjectsStat.count==0) {
        NSLog(@"no stat with ID %i found",[_deckID intValue]);
    }
    
    for (NSManagedObject *fetchedDeck in fetchedObjectsStat)
    {
        NSManagedObject *statToReset = [fetchedDeck valueForKeyPath:@"stat"];
        NSString *stringToSave = [[NSString alloc]init];
        stringToSave = @"0,0,0,0,0,0,0,0,0";
        [statToReset setValue:stringToSave forKey:@"wins"];
        [statToReset setValue:stringToSave forKey:@"losses"];
    }

    
    
    for(StatsEntryObject *st in _currentStat)
    {
        st.wins=0;
        st.losses=0;
        st.time=0.0;
    }
    [self readStatEntries];
    [_taView reloadData];
}
- (void)setDetailItem:(id)newStat
{
    if (_currentStat != newStat) {
        _currentStat = [[NSArray alloc]initWithArray:newStat];
    }
}
-(void)setDeckID:(NSNumber *)deckID
{
    _deckID = deckID;
    NSLog(@"sent deckID");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 9;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DisplayStatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classCell" forIndexPath:indexPath];
    
    // Configure the cell...
 /*
    NSArray *imageNames = @[@"win_1.png", @"win_2.png", @"win_3.png", @"win_4.png",
                            @"win_5.png", @"win_6.png", @"win_7.png", @"win_8.png",
                            @"win_9.png", @"win_10.png", @"win_11.png", @"win_12.png",
                            @"win_13.png", @"win_14.png", @"win_15.png", @"win_16.png"];
    
    
    
    cell.barImage.animationImages = imageNames;
    cell.barImage.animationDuration = 1;
    cell.barImage.animationRepeatCount = 0;
    [cell.barImage startAnimating];
 */
    
    StatsEntryObject *entry = [_currentStat objectAtIndex:indexPath.row];
    
    int games = entry.wins + entry.losses;
    float scale;
    if (games>0) {
        if (entry.losses>0) {
            scale =  (float)entry.wins/games;
        }else scale=1;
        
        cell.barImage.transform = CGAffineTransformMakeScale(scale, 1);
        cell.barImage.image = [UIImage imageNamed:@"win_16.png"];
    }
    
    
    switch (indexPath.row) {
        case 0:
            cell.className.text = @"Warrior";
            break;
        case 1:
            cell.className.text = @"Shaman";
            break;
            
        case 2:
            cell.className.text = @"Rogue";
            break;
        case 3:
            cell.className.text = @"Paladin";
            break;
        case 4:
            cell.className.text = @"Hunter";
            break;
        case 5:
            cell.className.text = @"Druid";
            break;
        case 6:
            cell.className.text = @"Warlock";
            break;
        case 7:
            cell.className.text = @"Mage";
            break;
        case 8:
            cell.className.text = @"Priest";
            break;

        default:
            break;
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

- (IBAction)exitNow:(id)sender {
    [self dismissViewControllerAnimated:YES completion: ^{
        NSLog(@"dismissed");
    }];
}
@end

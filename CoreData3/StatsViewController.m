//
//  StatsViewController.m
//  CoreData3
//
//  Created by Pascal on 20/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import "StatsViewController.h"

@interface StatsViewController ()

@end

@implementation StatsViewController

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
    _stats = [[NSArray alloc]init];
    _stats = _selectedDeck.statsEntries;
    
    _picsArray
    = [[NSMutableArray alloc]init];
    [_picsArray addObject:_warriorPic];
    [_picsArray addObject:_shamanPic];
    [_picsArray addObject:_roguePic];
    [_picsArray addObject:_paladinPic];
    [_picsArray addObject:_hunterPic];
    [_picsArray addObject:_druidPic];
    [_picsArray addObject:_warlockPic];
    [_picsArray addObject:_magePic];
    [_picsArray addObject:_priestPic];
    
    
}
+(void)createStatEntities:(DeckObject *)selDeck
{
    selDeck.didCreateStatEntities=true;
    CoreData3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    NSLog(@"createdCDStat");
    
    //sets createdStat in CD to true
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDeck = [NSEntityDescription
                                       entityForName:@"DecksDB" inManagedObjectContext:context];
    [fetchRequest setEntity:entityDeck];
    
    NSPredicate *predDeck = [NSPredicate predicateWithFormat:@"(deckID = %i)", [selDeck.deckID intValue]];
    [fetchRequest setPredicate:predDeck];
     
    NSArray *fetchedObjectsStat = [context executeFetchRequest:fetchRequest error:&error];
    
    
    
    
    //create StatEntities in CD
    
    NSManagedObject *newStat = [NSEntityDescription insertNewObjectForEntityForName:@"StatsDB"inManagedObjectContext:context];
    [newStat setValue:selDeck.deckID forKey:@"deckID"];
    
    NSLog(@"stat created for ID %i",[selDeck.deckID intValue]);
    
    NSString *stringToSave = [[NSString alloc]init];
    
       
    stringToSave = @"0,1,2,3,4,5,6,7,8";
    [newStat setValue:stringToSave forKey:@"classID"];
    (stringToSave = @"0,0,0,0,0,0,0,0,0");
    [newStat setValue:stringToSave forKey:@"wins"];
    [newStat setValue:stringToSave forKey:@"losses"];
    [newStat setValue:selDeck.deckID forKeyPath:@"deckID"];

    
    //sollte eh nur einmal ausgeführt werden
    for (NSManagedObject *fetchedDeck in fetchedObjectsStat)
    {
       // [fetchedDeck setValue:[NSNumber numberWithBool:true] forKey:@"createdStat"]; did this in MyDecks already
        [fetchedDeck setValue:newStat forKey:@"stat"];
    }
    
    [context save:&error];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setDetailItem:(id)newBO
{
    if (_selectedDeck != newBO) {
        _selectedDeck = [[DeckObject alloc]init];
        _selectedDeck = newBO;
        NSLog(@"statobj set");
    }else NSLog(@"no detail item set");
    
}
-(IBAction)selectWarrior:(id)sender {
    _selClass = 0;
    [self hideOtherClasses:_selClass];
}

- (IBAction)selectShaman:(id)sender {
    _selClass = 1;
    [self hideOtherClasses:_selClass];
}

- (IBAction)selectRogue:(id)sender {
    _selClass = 2;
    [self hideOtherClasses:_selClass];
}

- (IBAction)selectPaladin:(id)sender {
    _selClass = 3;
    [self hideOtherClasses:_selClass];
}
- (IBAction)selectHunter:(id)sender {
    _selClass = 4;
    [self hideOtherClasses:_selClass];
}

- (IBAction)selectDruid:(id)sender {
    _selClass = 5;
   [self hideOtherClasses:_selClass];
    
}

- (IBAction)selectWarlock:(id)sender {
    _selClass = 6;
    [self hideOtherClasses:_selClass];
}

- (IBAction)selectMage:(id)sender {
    _selClass = 7;
    [self hideOtherClasses:_selClass];
}

- (IBAction)selectPriest:(id)sender {
    _selClass = 8;
    [self hideOtherClasses:_selClass];
}
- (void)hideOtherClasses:(int)activeClass
{
    ((UIButton *) [_picsArray objectAtIndex:activeClass]).alpha = 1;
    for (int i=0; i<_picsArray.count; i++) {
        if (i!=activeClass) {
            ((UIButton *) [_picsArray objectAtIndex:i]).alpha = 0.5;
        }
    }
}
- (IBAction)saveStats:(id)sender {
    (_resultSwitch.isOn)?
    [_selectedDeck addWinTo:_selClass atTime:_timeSlider.value] : [_selectedDeck addLossTo:_selClass atTime:_timeSlider.value];

    CoreData3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"StatsDB" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(deckID = %i)",[_selectedDeck.deckID intValue]];
    [fetchRequest setPredicate:pred];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count>1) {
        NSLog(@"multiple Stats with same ID!");
    }else
    {
        if (fetchedObjects.count==0) {
            NSLog(@"No Stat with ID %i found",[_selectedDeck.deckID intValue]);
        }else
        {
        NSManagedObject *stat = [fetchedObjects objectAtIndex:0];
        StatsEntryObject *entry = [_selectedDeck.statsEntries objectAtIndex:_selClass];
        NSArray *winsCD = [[NSMutableArray alloc]init];
        (_resultSwitch.isOn)?
            (winsCD = [[stat valueForKey:@"wins"] componentsSeparatedByString:@","]):
            (winsCD = [[stat valueForKey:@"losses"] componentsSeparatedByString:@","]);
        
        NSMutableArray *winsCDMut = [[NSMutableArray alloc]initWithArray:winsCD];
        (_resultSwitch.isOn)?
        ([winsCDMut replaceObjectAtIndex:_selClass withObject:[NSNumber numberWithInt:entry.wins] ]):
        ([winsCDMut replaceObjectAtIndex:_selClass withObject:[NSNumber numberWithInt:entry.losses] ]);
        
        NSString *newStat = [[NSString alloc]initWithString:[winsCDMut componentsJoinedByString:@","]];
        (_resultSwitch.isOn)? [stat setValue:newStat  forKey:@"wins"]:[stat setValue:newStat  forKey:@"losses"] ;
    }
    
    
    
    [context save:&error];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    }}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
    
 }


- (IBAction)exitNow:(id)sender {
    [self dismissViewControllerAnimated:YES completion: ^{
        NSLog(@"dismissed");
    }];
}
@end

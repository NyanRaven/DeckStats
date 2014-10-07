//
//  StatsViewController.h
//  CoreData3
//
//  Created by Pascal on 20/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeckObject.h"
#import "CoreData3AppDelegate.h"
#import "StatsEntryObject.h"

@interface StatsViewController : UIViewController
- (IBAction)exitNow:(id)sender;
@property (nonatomic) NSArray *stats;
@property (nonatomic) NSMutableArray *picsArray;
@property (nonatomic) int selClass;
@property(nonatomic)DeckObject *selectedDeck;
//@property (nonatomic, strong) StatsEntryObject *
@property (strong, nonatomic) IBOutlet UIButton *warriorPic;
@property (strong, nonatomic) IBOutlet UIButton *shamanPic;
@property (strong, nonatomic) IBOutlet UIButton *roguePic;
@property (strong, nonatomic) IBOutlet UIButton *paladinPic;
@property (strong, nonatomic) IBOutlet UIButton *hunterPic;
@property (strong, nonatomic) IBOutlet UIButton *druidPic;
@property (strong, nonatomic) IBOutlet UIButton *warlockPic;
@property (strong, nonatomic) IBOutlet UIButton *magePic;
@property (strong, nonatomic) IBOutlet UIButton *priestPic;

@property (strong, nonatomic) IBOutlet UISwitch *resultSwitch;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
- (void)setDetailItem:(id)newBO;
+(void)createStatEntities:(DeckObject *)selDeck;
- (IBAction)selectWarrior:(id)sender;
- (IBAction)selectShaman:(id)sender;
- (IBAction)selectRogue:(id)sender;
- (IBAction)selectPaladin:(id)sender;
- (IBAction)selectHunter:(id)sender;
- (IBAction)selectDruid:(id)sender;
- (IBAction)selectWarlock:(id)sender;
- (IBAction)selectMage:(id)sender;
- (IBAction)selectPriest:(id)sender;
@property (strong, nonatomic) IBOutlet UISlider *timeSlider;
- (IBAction)saveStats:(id)sender;
- (IBAction)exitNow:(id)sender;

@end

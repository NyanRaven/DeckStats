//
//  DisplayStatsViewController.h
//  CoreData3
//
//  Created by Pascal on 20/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatsEntryObject.h"
#import "DisplayStatsTableViewCell.h"
#import "CoreData3AppDelegate.h"

@interface DisplayStatsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
- (IBAction)exitNow:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *totalWinsLabel;
@property (strong, nonatomic) IBOutlet UILabel *longestStreakLabel;
@property (strong, nonatomic) IBOutlet UILabel *winPercLabel;
@property IBOutlet UITableView *taView;
@property (nonatomic) int totalGames;
@property (nonatomic,retain) NSNumber* deckID;
@property (nonatomic)NSArray *currentStat;
- (void)setDetailItem:(id)newBO;
@end

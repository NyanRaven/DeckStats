//
//  FeaturedDeckCardViewController.h
//  CoreData3
//
//  Created by Pascal on 06/05/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeckObject.h"
#import "CardObject.h"
#import "featuredTableViewCell.h"
#import "MyDecksTableViewController.h"
#import "CoreData3AppDelegate.h"
#import "StatsViewController.h"
#import "DSBarChart.h"

@interface FeaturedDeckCardViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *barImage1;
@property (strong, nonatomic) IBOutlet UIImageView *barImage2;
@property (strong, nonatomic) IBOutlet UIImageView *barImage3;
@property (strong, nonatomic) IBOutlet UIImageView *barImage4;
@property (strong, nonatomic) IBOutlet UIImageView *barImage5;
@property (strong, nonatomic) IBOutlet UIImageView *barImage6;
@property (strong, nonatomic) IBOutlet UIImageView *barImage7;
@property IBOutlet UITableView *taView;
@property(nonatomic)DeckObject *selectedDeck;
@property (strong, nonatomic) IBOutlet UIView *chartView;

- (IBAction)download:(id)sender;
@property(nonatomic)NSMutableArray *barImages, *deckCosts;

- (void)setDetailItem:(id)newBO;

@end

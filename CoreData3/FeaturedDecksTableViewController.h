//
//  FeaturedDecksTableViewController.h
//  CoreData3
//
//  Created by Pascal on 01/05/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DeckObject.h"
#import "CardObject.h"
#import "CoreData3AppDelegate.h"
#import "MyDecksTableViewController.h"
#import "MyDecksTableViewCell.h"
#import "FeaturedDeckCardViewController.h"

@interface FeaturedDecksTableViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource>

@property NSMutableArray *featuredDecks;
@property NSMutableArray *assignedIDs;
@end

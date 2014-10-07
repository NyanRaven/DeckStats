//
//  featuredDeckTableViewController.h
//  CoreData3
//
//  Created by Pascal on 06/05/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "featuredTableViewCell.h"
#import "DeckObject.h"
#import "CardObject.h"

@interface featuredDeckTableViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property IBOutlet UITableView *taView;
@property(nonatomic)DeckObject *selectedDeck;
- (void)setDetailItem:(id)newBO;
@end

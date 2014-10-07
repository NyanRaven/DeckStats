//
//  DeckTableViewCell.h
//  CoreData3
//
//  Created by Pascal on 18/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeckTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *isDoubleIcon;

@property (strong, nonatomic) IBOutlet UILabel *cardNameLabel;

@end

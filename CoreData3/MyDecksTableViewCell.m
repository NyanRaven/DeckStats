//
//  MyDecksTableViewCell.m
//  CoreData3
//
//  Created by Pascal on 19/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import "MyDecksTableViewCell.h"
@implementation MyDecksTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

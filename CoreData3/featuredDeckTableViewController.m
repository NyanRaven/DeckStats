//
//  featuredDeckTableViewController.m
//  CoreData3
//
//  Created by Pascal on 06/05/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import "featuredDeckTableViewController.h"

@interface featuredDeckTableViewController ()

@end

@implementation featuredDeckTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    _taView.delegate = self;
    _taView.dataSource = self;
    [_taView reloadData];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selectedDeck = [[DeckObject alloc]init];
}
- (void)setDetailItem:(id)newBO
{
    if (_selectedDeck != newBO) {
        _selectedDeck = [[DeckObject alloc]init];
        _selectedDeck = newBO;
    }
    NSLog(@"%lu cards in deck",(unsigned long)_selectedDeck.cards.count);
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _selectedDeck.cards.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    featuredTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Card" forIndexPath:indexPath];
    
    // Configure the cell...
    CardObject *card = [_selectedDeck.cards objectAtIndex:indexPath.row];
    
    //cell.isDoubleIcon.hidden = true;
    cell.cardNameLabel.text = @"test";// card.cardName;
    NSLog(@"%@",card.cardName);
    if (card.isDouble) {
        cell.isDoubleIcon.hidden = false;
    }
    cell.isDoubleIcon.hidden = false;
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

@end

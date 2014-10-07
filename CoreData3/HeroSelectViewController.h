//
//  HeroSelectViewController.h
//  CoreData3
//
//  Created by Pascal on 17/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeckCreatorViewController.h"

@interface HeroSelectViewController : UIViewController
{
     int *hero;
}
@property (strong, nonatomic) IBOutlet UIImageView *bigHeroImage;
@property (nonatomic, retain) NSNumber *deckID;
@property (nonatomic) NSString *selectedHero;

- (IBAction)warriorSelect:(id)sender;
- (IBAction)shamanSelect:(id)sender;
- (IBAction)rogueSelect:(id)sender;
- (IBAction)paladinSelect:(id)sender;
- (IBAction)hunterSelect:(id)sender;
- (IBAction)druidSelect:(id)sender;
- (IBAction)warlockSelect:(id)sender;
- (IBAction)mageSelect:(id)sender;
- (IBAction)priestSelect:(id)sender;
- (IBAction)exitNow:(id)sender;

@end

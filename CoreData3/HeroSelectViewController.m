//
//  HeroSelectViewController.m
//  CoreData3
//
//  Created by Pascal on 17/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import "HeroSelectViewController.h"

@interface HeroSelectViewController ()

@end

@implementation HeroSelectViewController

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
    hero = 0;
    _selectedHero = @"noHero";
   // [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper1Ret.jpg"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)warriorSelect:(id)sender {
    UIImage *heroImage;
    heroImage = [UIImage imageNamed:@"warrior.png"];
    _bigHeroImage.image = heroImage;
    _selectedHero = @"warrior";
}

- (IBAction)rogueSelect:(id)sender {
    UIImage *heroImage;
    heroImage = [UIImage imageNamed:@"rogue.png"];
    _bigHeroImage.image = heroImage;
    _selectedHero = @"rogue";
}



- (IBAction)shamanSelect:(id)sender {
    UIImage *heroImage;
    heroImage = [UIImage imageNamed:@"shaman.png"];
    _bigHeroImage.image = heroImage;
    _selectedHero = @"shaman";
}
- (IBAction)paladinSelect:(id)sender {
    UIImage *heroImage;
    heroImage = [UIImage imageNamed:@"paladin.png"];
    _bigHeroImage.image = heroImage;
    _selectedHero = @"paladin";
}

- (IBAction)hunterSelect:(id)sender {
    UIImage *heroImage;
    heroImage = [UIImage imageNamed:@"hunter.png"];
    _bigHeroImage.image = heroImage;
    _selectedHero = @"hunter";
}
- (IBAction)druidSelect:(id)sender {
    UIImage *heroImage;
    heroImage = [UIImage imageNamed:@"druid.png"];
    _bigHeroImage.image = heroImage;
    _selectedHero = @"druid";
}

- (IBAction)warlockSelect:(id)sender {
    UIImage *heroImage;
    heroImage = [UIImage imageNamed:@"warlock.png"];
    _bigHeroImage.image = heroImage;
    _selectedHero = @"warlock";
}

- (IBAction)mageSelect:(id)sender {
    UIImage *heroImage;
    heroImage = [UIImage imageNamed:@"mage.png"];
    _bigHeroImage.image = heroImage;
    _selectedHero = @"mage";
}

- (IBAction)priestSelect:(id)sender {
    UIImage *heroImage;
    heroImage = [UIImage imageNamed:@"priest.png"];
    _bigHeroImage.image = heroImage;
    _selectedHero = @"priest";
}

- (IBAction)exitNow:(id)sender {
    [self dismissViewControllerAnimated:YES completion: ^{
        NSLog(@"dismissed");
    }];
}

#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([_selectedHero isEqualToString:@"noHero"]&& [identifier isEqualToString:@"createDeck"]) {
        return NO;
    }
    return YES;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"createDeck"]) {
    DeckCreatorViewController *VC = [segue destinationViewController];
    VC.Hero = _selectedHero;
    VC.deckID = _deckID;
    }

    
}
@end

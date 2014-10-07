//
//  HeroSelectionViewController.m
//  CoreData3
//
//  Created by Pascal on 16/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import "HeroSelectionViewController.h"

@interface HeroSelectionViewController ()

@end

@implementation HeroSelectionViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HeroCell *myCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell"forIndexPath: indexPath];
    UIImage *image;
   // long row = [indexPath row];
    image = [UIImage imageNamed:@"smart_fortwo.jpg"]; myCell.HeroImage.image = image;
    return myCell;
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

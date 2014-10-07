//
//  FeaturedFilterViewController.h
//  Deck Stats
//
//  Created by Pascal on 07/10/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturedFilterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *firstSegment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *secondSegment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *thirdSegment;
- (IBAction)firstSegmentTouched:(id)sender;
- (IBAction)secondSegmentTouched:(id)sender;
- (IBAction)thirdSegmentTouched:(id)sender;

@end

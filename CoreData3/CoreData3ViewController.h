//
//  CoreData3ViewController.h
//  CoreData3
//
//  Created by Pascal on 13/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData3AppDelegate.h"

@interface CoreData3ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *atk;
@property (strong, nonatomic) IBOutlet UITextField *def;

@property (strong, nonatomic) IBOutlet UITextField *mana;
@property (strong, nonatomic) IBOutlet UITextView *text;
@property (strong, nonatomic) IBOutlet UITextField *kind;
- (IBAction)saveData:(id)sender;
- (IBAction)findData:(id)sender;
-(IBAction)textFieldReturn:(id)sender;
- (IBAction)setData:(id)sender;
@end

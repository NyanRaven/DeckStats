//
//  CoreData3ViewController.m
//  CoreData3
//
//  Created by Pascal on 13/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import "CoreData3ViewController.h"

@interface CoreData3ViewController ()

@end

@implementation CoreData3ViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([_name isFirstResponder] && [touch view] != _name) {
        [_name resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}
-(IBAction)setData:(id)sender
{
    CoreData3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"cards2" ofType:@"json"];
    NSArray* Cards = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]options:kNilOptions error:&err];
    
    NSLog(@"cards to save %lu",(unsigned long)Cards.count);
    for(NSDictionary *item in Cards) {
        NSLog(@"load...");
        //BOOL coll = [[item valueForKey:@"collectible"] boolValue];
       //if ( [[item valueForKey:@"collectible"] boolValue] ) {
        if ([[item valueForKey:@"type"] isEqualToString:@"minion"]) {
            
            NSManagedObject *newMinion;
            newMinion = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
            [newMinion setValue: [item valueForKey:@"name"] forKey:@"name"];
            [newMinion setValue:[item valueForKey:@"description"] forKey:@"text"];
            [newMinion setValue: [item valueForKey:@"attack"]  forKey:@"atk"];
            [newMinion setValue: [item valueForKey:@"mana"]  forKey:@"cost"];
            [newMinion setValue: [item valueForKey:@"health"] forKey:@"def"];
            [newMinion setValue: [item valueForKey:@"type"] forKey:@"kind"];
            [newMinion setValue: [item valueForKey:@"id"] forKey:@"id"];
            [newMinion setValue:[item valueForKey:@"class"] forKey:@"hero"];
            NSError *error;
            [context save:&error];
            
        }
        if ([[item valueForKey:@"type"]isEqualToString:@"spell"]) {
            NSManagedObject *newSpell;
            newSpell = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
            [newSpell setValue: [item valueForKey:@"name"] forKey:@"name"];
            [newSpell setValue:[item valueForKey:@"description"] forKey:@"text"];
            [newSpell setValue: [item valueForKey:@"mana"]  forKey:@"cost"];
            [newSpell setValue: [item valueForKey:@"type"] forKey:@"kind"];
            [newSpell setValue: [item valueForKey:@"id"] forKey:@"id"];
            [newSpell setValue: [item valueForKey:@"set"] forKey:@"kind"];
            [newSpell setValue:[item valueForKey:@"class"] forKey:@"hero"];
            NSError *error;
            [context save:&error];
        }
        
            if ([[item valueForKey:@"type"]isEqualToString:@"weapon"]) {
                NSManagedObject *newWeapon;
                newWeapon = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
                [newWeapon setValue: [item valueForKey:@"name"] forKey:@"name"];
                [newWeapon setValue:[item valueForKey:@"description"] forKey:@"text"];
                [newWeapon setValue: [item valueForKey:@"type"] forKey:@"kind"];
                [newWeapon setValue: [item valueForKey:@"set"] forKey:@"kind"];
                [newWeapon setValue: [item valueForKey:@"id"] forKey:@"id"];
                [newWeapon setValue: [item valueForKey:@"attack"]  forKey:@"atk"];
                [newWeapon setValue: [item valueForKey:@"mana"]  forKey:@"cost"];
                [newWeapon setValue: [item valueForKey:@"health"] forKey:@"def"];
                [newWeapon setValue:[item valueForKey:@"class"] forKey:@"hero"];
                NSError *error;
                [context save:&error];
            }

    }
}
- (IBAction)saveData:(id)sender {
    CoreData3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext]; NSManagedObject *newContact;
    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
    [newContact setValue: _name.text forKey:@"name"];
    [newContact setValue: _text.text forKey:@"text"];
    [newContact setValue:_kind.text forKey:@"kind"];
    [newContact setValue: [NSNumber numberWithInt:[_atk.text intValue]]  forKey:@"atk"];
    [newContact setValue: [NSNumber numberWithInt:[_def.text intValue]] forKey:@"def"];
    
    _name.text = @"";
    _atk.text = @"";
    _def.text = @"";
    _text.text = @"";
    _kind.text = @"";
    
    NSError *error;
    [context save:&error];
}

- (IBAction)findData:(id)sender {
    CoreData3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name = %@)",
     _name.text];
    [request setPredicate:pred];
    NSManagedObject *matches = nil;
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    if ([objects count] == 0) {
        _name.text = @"No matches";
    } else {
        matches = objects[0];
    }

    _name.text = [matches valueForKey:@"name"];
    _text.text = [matches valueForKey:@"text"];
    _atk.text = [[matches valueForKey:@"atk"] stringValue];
    _def.text = [[matches valueForKey:@"def"] stringValue];
    _kind.text = [matches valueForKey:@"kind"];
    _mana.text = [[matches valueForKey:@"cost"] stringValue];
    
}
-(IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
}


@end

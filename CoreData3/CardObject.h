//
//  CardObject.h
//  CoreData3
//
//  Created by Pascal on 18/04/14.
//  Copyright (c) 2014 Pascal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardObject : NSObject
{
   
}
@property (nonatomic) NSInteger mana;
@property (nonatomic) NSInteger cardID, atk, def;
@property (nonatomic) NSString *cardName,*description,*kind,*quality;
@property (nonatomic) BOOL isDouble;
@end

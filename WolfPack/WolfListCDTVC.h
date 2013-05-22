//
//  WolfListCDTVC.h
//  WolfPack
//
//  Created by Francois Chaubard on 3/1/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface WolfListCDTVC : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


-(void)changeMode:(int)mode; // 0 is user is not hungry, 1 is user is hungry

@end

//
//  PopoverTVC.h
//  WolfPack
//
//  Created by Francois Chaubard on 5/25/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContainerViewController;

@interface PopoverTVC : UITableViewController

@property (strong,nonatomic) NSMutableArray *adjectives;
@property(nonatomic,assign) ContainerViewController *delegate;

@end

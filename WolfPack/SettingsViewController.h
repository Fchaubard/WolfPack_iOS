//
//  SettingsViewController.h
//  WolfPack
//
//  Created by Jesus Mora on 4/21/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditSettingsViewController.h"
#import "ULTDataViewController.h"
#import "MyManagedObjectContext.h"
#import "ULTFriendsList.h"

@interface SettingsViewController : UIViewController

- (void)switchViews:(BOOL)showSettings;
- (IBAction)unwindFromEditScreen:(UIStoryboardSegue *)segue;


@end

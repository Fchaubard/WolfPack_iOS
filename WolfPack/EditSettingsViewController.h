//
//  EditSettingsViewController.h
//  WolfPack
//
//  Created by Jesus Mora on 4/24/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@interface EditSettingsViewController : UIViewController <UITextFieldDelegate>
/*
 Depending on type of edit (name, password, email) property 1, 2, and 3 will
 reflect different data which is why I decided vague identifiers.
*/
@property NSString *editType;
@property NSString *property1;
@property NSString *property2;
@property NSString *property3;
@end

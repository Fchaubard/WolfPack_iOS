//
//  ULTSignUpViewController.h
//  UserLoginTest
//
//  Created by Rebecca Rich on 4/21/13.
//  Copyright (c) 2013 Rebecca Rich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ULTSignUpViewController : UIViewController
- (IBAction)loginNeeded:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirm;
@property (weak, nonatomic) IBOutlet UITextField *firstname;
@property (weak, nonatomic) IBOutlet UITextField *lastname;
@property (weak, nonatomic) IBOutlet UITextField *pNumber;

@end

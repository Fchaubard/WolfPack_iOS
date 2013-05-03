//
//  ULTDataViewController.h
//  UserLoginTest
//
//  Created by Rebecca Rich on 3/4/13.
//  Copyright (c) 2013 Rebecca Rich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ULTDataViewController : UIViewController <UITextFieldDelegate>{
    // Database variables
	NSString *databaseName;
	NSString *databasePath;
}

- (IBAction)loginButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (IBAction)signUpNeeded:(id)sender;
- (IBAction)unwindFromLogoutButton:(UIStoryboardSegue *)segue;
@end

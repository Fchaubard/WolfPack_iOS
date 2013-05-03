//
//  SettingsViewController.m
//  WolfPack
//
//  Created by Jesus Mora on 4/21/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *fname;
@property (weak, nonatomic) IBOutlet UILabel *lname;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *password;


@end

@implementation SettingsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
 To-do: handle case when there are spaces or special character in the name
 */

- (IBAction)unwindFromEditScreen:(UIStoryboardSegue *)segue
{
    NSString *sessionid =[[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
	EditSettingsViewController *edit = (EditSettingsViewController *)segue.sourceViewController;
	UIAlertView *message;
	NSString *tempProp1 = [edit.property1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    tempProp1 = [tempProp1 stringByReplacingOccurrencesOfString:@" " withString:@"!!_____!_____!!"];
	NSString *tempProp2 = [edit.property2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    tempProp2 = [tempProp2 stringByReplacingOccurrencesOfString:@" " withString:@"!!_____!_____!!"];
	NSString *tempProp3 = [edit.property3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    tempProp3 = [tempProp3 stringByReplacingOccurrencesOfString:@" " withString:@"!!_____!_____!!"];
	if([edit.editType isEqualToString:@"editName"]) {
		if(tempProp1.length > 0 && tempProp2.length > 0) {
			self.fname.text = edit.property1;
			self.lname.text = edit.property2;
		
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/editnamejson.php?session=%@&fname=%@&lname=%@",sessionid, edit.property1,edit.property2]]; //Jesus
			NSURLRequest *request = [NSURLRequest requestWithURL:url];
			
			NSURLResponse *res;
			NSError *err;
			
			NSData *resData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
			NSString *resString = [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
			
			if(!err && ![resString isEqualToString:@"error: could not edit name"]) {
				message = [[UIAlertView alloc] initWithTitle:@"Edit Name Success" message:@"Successful attempt to edit name." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
			}
		}
		if (message == nil) {
			message = [[UIAlertView alloc] initWithTitle:@"Edit Name Error" message:@"Unsuccessful attempt to edit name." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		}
	} else if([edit.editType isEqualToString:@"editPassword"]) {
		if([tempProp2 isEqualToString:tempProp3] && tempProp2.length > 0) {
			
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/editpasswordjson.php?session=%@&current=%@New&new=%@", sessionid, edit.property1, edit.property2]]; //Jesus
			NSURLRequest *request = [NSURLRequest requestWithURL:url];
			
			NSURLResponse *res;
			NSError *err;
			
			NSData *resData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
			NSString *resString = [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
						
			if(!err && ![resString isEqualToString:@"error: password not updated"]) {
				message = [[UIAlertView alloc] initWithTitle:@"Password Reset" message:@"Successful reset of your password." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
			} 
		}
		if(message == nil) {
			message = [[UIAlertView alloc] initWithTitle:@"Reset Password Error" message:@"Unsuccessful attempt to reset your password." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		}
	} else if([edit.editType isEqualToString:@"editEmail"]) {
		if([tempProp1 isEqualToString:tempProp2] && tempProp1.length > 0) {
			
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/editemailjson.php?session=%@&email=%@",sessionid, edit.property1]]; //Jesus
			NSURLRequest *request = [NSURLRequest requestWithURL:url];
			
			NSURLResponse *res;
			NSError *err;
			
			NSData *resData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
			NSString *resString = [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
			
			if(!err && ![resString isEqualToString:@"error: email not updated"]) {
				self.email.text = edit.property1;
				message = [[UIAlertView alloc] initWithTitle:@"Email Updated" message:@"Successful update of your email." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
			}
		}
		if(message == nil) {
			message = [[UIAlertView alloc] initWithTitle:@"Email Update Error" message:@"Unsuccessful attempt to update your email." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		}
	}
	[message show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
        

        if([segue.identifier isEqualToString:@"editName"]) {
            EditSettingsViewController *edit = (EditSettingsViewController *)segue.destinationViewController;
            edit.editType = @"editName";
            edit.property1 = self.fname.text;
            edit.property2 = self.lname.text;
        } else if([segue.identifier isEqualToString:@"editPassword"]) {
            EditSettingsViewController *edit = (EditSettingsViewController *)segue.destinationViewController;
            edit.editType = @"editPassword";
        } else if([segue.identifier isEqualToString:@"editEmail"]) {
            EditSettingsViewController *edit = (EditSettingsViewController *)segue.destinationViewController;
            edit.editType = @"editEmail";
            edit.property1 = self.email.text;
        } else if ([segue.identifier isEqualToString:@"addFriends"]){
            
        }
    
}





- (void)displaySettings
{
	//Stack overflow query: How to execute URL requests from an iOS application?
	NSString *sessionid =[[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/getwpuserjson.php?session=%@", sessionid]]; //Jesus
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *res;
    NSError *err;
	
    NSData *resData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
    NSString *resString = [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
	
    NSString *errorString = @"error: user not found in database";
    
    if(!err && ![resString isEqualToString:errorString]) {
        NSRange fname = [resString rangeOfString:@"fname\":\""];
        NSRange lname = [resString rangeOfString:@"lname\":\""];
        NSRange email = [resString rangeOfString:@"email\":\""];
        NSRange adjective = [resString rangeOfString:@"adjective\":\""];
        
        int extraChars = 3;
        NSInteger fnameIdx = fname.location + fname.length;
        NSInteger lnameIdx = lname.location + lname.length;
        NSInteger emailIdx = email.location + email.length;
        
        self.fname.text = [resString substringWithRange:NSMakeRange(fnameIdx, lname.location - fnameIdx - extraChars)];
        self.lname.text = [resString substringWithRange:NSMakeRange(lnameIdx, email.location - lnameIdx - extraChars)];
        self.email.text = [resString substringWithRange:NSMakeRange(emailIdx, adjective.location - emailIdx - extraChars)];
		self.password.text = @"********";
    } else {
        self.fname.text = @"unavailable";
        self.lname.text = @"unavailable";
        self.email.text = @"unavailable";
		self.password.text = @"unavailable";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [self displaySettings];
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)view setContentOffset:CGPointMake(0, 0)];
        }
    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

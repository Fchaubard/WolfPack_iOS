//
//  ULTSignUpViewController.m
//  UserLoginTest
//
//  Created by Rebecca Rich on 4/21/13.
//  Copyright (c) 2013 Rebecca Rich. All rights reserved.
//

#import "ULTSignUpViewController.h"
#import "MyManagedObjectContext.h"
@interface ULTSignUpViewController ()

@end

@implementation ULTSignUpViewController
@synthesize username;
@synthesize password;
@synthesize passwordConfirm;
@synthesize firstname;
@synthesize lastname;
@synthesize pNumber;

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

- (bool)checkSignUpRequest:(NSString *)fname lastName:(NSString *)lname email:(NSString *)uname withPassword:(NSString *)pword andConfirmation:(NSString *)cpword pn:(NSString *)pNumber_this{
    
    if(![pword isEqualToString:cpword]){ //Immediate Failure if Password and Confirmation Password do not match.
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Passwords do not match.  Please Try Again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
        return false;
    }
    NSString *token = [MyManagedObjectContext deviceToken];
    NSString *urlString = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/signupjson.php?fname=%@&lname=%@&email=%@&password=%@&phoneNumber=%@&pushtoken=%@", fname, lname, uname, pword,pNumber_this, token];
    
     urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"!!_____!_____!!"];
    NSLog(@"URLSTRING: %@",urlString);
    
    
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:urlString]];
    NSString *serverOutput = [[NSString alloc] initWithData:data
                                                   encoding: NSUTF8StringEncoding];
    NSLog(@"Server Output: %@",serverOutput);
    
    if([serverOutput isEqualToString:@"phone number already has account"]){
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Account for this Phone Number Already Exists. Please Correct the Information Given or Continue to the Login Screen." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];
        return false;
    }
    else{
        //Store the token...
        NSString *title = [NSString stringWithFormat:@"Sign Up Success for Number: %@", serverOutput];
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:title message:@"Welcome to Wolfpack!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertsuccess show];
        return true;
    }
    return false;
    
}

- (IBAction)signUpRequested:(id)sender {
    NSLog(@"Login Button Pressed");
    NSString *fname = [self.firstname text];
    NSString *lname = [self.lastname text];
    NSString *usernameEntry = [self.username text];
    NSString *passwordEntry = [self.password text];
    NSString *passwordConfirmation = [self.passwordConfirm text];
    NSString *phoneNumber = [self.pNumber text];
    BOOL signUpOkay = [self checkSignUpRequest:fname lastName:lname email:usernameEntry withPassword:passwordEntry andConfirmation:passwordConfirmation pn:phoneNumber];

    
    //Segue Control:
    if (signUpOkay){
        //Login: Not necessary - built in functionality with sign up...
        //NSString *urlString = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/loginjson.php?email=%@&password=%@", usernameEntry, passwordEntry];
        //NSLog(@"URLSTRING: %@",urlString);
        //NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:urlString]];
        //NSString *serverOutput = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
        //NSLog(@"Server Output: %@",serverOutput);
        
        ////Store the token...
        ////Save what is now the phone number in NSUserDefaults...
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        // saving an NSString
        [MyManagedObjectContext setToken:phoneNumber];
        [prefs setObject:phoneNumber forKey:@"token"]; //careful here...
        
        // This is suggested to synch prefs, but is not needed (I didn't put it in my tut)
        [prefs synchronize];
        
        //pushed???
        NSString *tokenPushed = [MyManagedObjectContext token];
        NSLog(@"Token Pushed: %@",tokenPushed);
        
        //Segue
        NSLog(@"SignUp Correct");
        [self performSegueWithIdentifier:@"signupLogin" sender:self]; //should really be to the settings page.... warning no friends yet!!
    }
    else{
        NSLog(@"Signup Incorrect");
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.firstname) {
        NSLog(@"Next Button Pressed");
        [theTextField resignFirstResponder];
        [self.lastname becomeFirstResponder];
    }
    else if (theTextField == self.lastname)
    {
        NSLog(@"Next Button Pressed Again");
        [theTextField resignFirstResponder];
        [self.username becomeFirstResponder];
    }
    else if (theTextField == self.username)
    {
        NSLog(@"Next Button Pressed Again");
        [theTextField resignFirstResponder];
        [self.password becomeFirstResponder];
    }
    else if (theTextField == self.password)
    {
        NSLog(@"Next Button Pressed Again");
        [theTextField resignFirstResponder];
        [self.passwordConfirm becomeFirstResponder];
    }
    else if (theTextField == self.passwordConfirm){
        NSLog(@"Next Button Pressed Again");
        [theTextField resignFirstResponder];
        [self.pNumber becomeFirstResponder];
    }
    else if (theTextField == self.pNumber){
        NSLog(@"Go Button Pressed");
        [theTextField resignFirstResponder];
        [self signUpRequested:self];
    }
    return YES;
}

- (IBAction)loginNeeded:(id)sender {
    NSLog(@"Login Screen Requested");
    [self performSegueWithIdentifier:@"backToLogin" sender:self];
}
@end

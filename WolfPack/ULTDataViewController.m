//
//  ULTDataViewController.m
//  UserLoginTest
//
//  Created by Rebecca Rich on 3/4/13.
//  Copyright (c) 2013 Rebecca Rich. All rights reserved.
//

#import "ULTDataViewController.h"

@interface ULTDataViewController ()
@end

@implementation ULTDataViewController

@synthesize UserName;
@synthesize Password;


- (IBAction)unwindFromLogoutButton:(UIStoryboardSegue *)segue
{
    NSString *sessionid =[[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/logoutjson.php?session=%@", sessionid]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *res;
    NSError *err;
    
    NSData *resData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&err];
    NSString *resString = [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
	
    NSString *errorString = @"error: logout error";
    UIAlertView *logoutMessage;
    
    if(!err && ![resString isEqualToString:errorString]) {
        logoutMessage = [[UIAlertView alloc] initWithTitle:@"Logout Success" message:@"You have successfully logged out!" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:nil forKey:@"token"];
        // This is suggested to synch prefs, but is not needed (I didn't put it in my tut) [Rebecca]
        [prefs synchronize];
    } else {
        logoutMessage = [[UIAlertView alloc] initWithTitle:@"Logout Error" message:@"Error was experienced while trying to logout. Please try again!" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    }
    
    [logoutMessage show];
}

- (bool)checkUserLoginInfo:(NSString *)uname withPassword:(NSString *)pword{ //uname is email i guess???
    
    //NSError *e = nil;
    NSString *urlString = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/loginjson.php?email=%@&password=%@", uname, pword];
    NSLog(@"URLSTRING: %@",urlString);
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:urlString]];
    NSString *serverOutput = [[NSString alloc] initWithData:data
                                                   encoding: NSUTF8StringEncoding];
    NSLog(@"Server Output: %@",serverOutput);
    
    if([serverOutput isEqualToString:@"already logged in"]){
            UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Already Logged In" message:@"Welcome to Wolfpack!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
            [alertsuccess show];
            return false;
    }
    else if([serverOutput isEqualToString:@"invalid login"]){
            UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username or Password Incorrect" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
            [alertsuccess show];
    }
    else{
        //Store the token...
            //Save what is now the phone number in NSUserDefaults...
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        // saving an NSString
        [prefs setObject:serverOutput forKey:@"token"];
        // This is suggested to synch prefs, but is not needed (I didn't put it in my tut)
        [prefs synchronize];
        
        //pushed???
        NSString *tokenPushed = [prefs stringForKey:@"token"];
        NSLog(@"Token Pushed: %@",tokenPushed);
        
        //
        
        NSString *title = [NSString stringWithFormat:@"Login Success: %@", serverOutput];
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:title message:@"Welcome to Wolfpack!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertsuccess show];
        return true;
    }
    
    return false;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
   if (theTextField == self.UserName) {
        NSLog(@"Next Button Pressed");
        [theTextField resignFirstResponder];
        [self.Password becomeFirstResponder];
    }
    else if (theTextField == self.Password)
    {
        NSLog(@"Go Button Pressed");
        [theTextField resignFirstResponder];
        [self loginButtonPressed:self];
    }
    return YES;
}

//- (void)keyboardDidShow:(NSNotification *)notification
//{
    //Assign new frame to your view
    //[self.view setFrame:CGRectMake(0,-176,320,460)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
//}

//-(void)keyboardDidHide:(NSNotification *)notification
//{
//    [self.view setFrame:CGRectMake(0,0,320,460)];
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UserName resignFirstResponder];
    [Password resignFirstResponder];
}

- (IBAction)signUpNeeded:(id)sender {
    NSLog(@"Sign up Requested");
    [self performSegueWithIdentifier:@"signUp" sender:self];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
   
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"token"]) {
        if ([[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"]!=@"no")
        {
            [self performSegueWithIdentifier: @"alreadyLoggedIn" sender: self];
        }else{
            NSLog(@"no device token");
        }
    }else{
        NSLog(@"not alraedy logged in");
    }

}

- (IBAction)loginButtonPressed:(id)sender {
    NSLog(@"Login Button Pressed");
    NSString *usernameEntry = [self.UserName text];
    NSString *passwordEntry = [self.Password text];
    BOOL check = [self checkUserLoginInfo:usernameEntry withPassword:passwordEntry];
    if (check){
    //if([usernameEntry isEqualToString:@"bob"] && [passwordEntry isEqualToString:@"Password"]){
        NSLog(@"Login Correct");
        [self performSegueWithIdentifier:@"loggingIn" sender:self];
    }
    else{
        NSLog(@"Login Incorrect");
    }
    
}
@end

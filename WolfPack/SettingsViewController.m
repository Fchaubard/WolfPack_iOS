//
//  SettingsViewController.m
//  WolfPack
//
//  Created by Jesus Mora on 4/21/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "SettingsViewController.h"
#import "MyManagedObjectContext.h"
@interface SettingsViewController ()

@property (strong, nonatomic) IBOutlet UILabel *name, *email, *password, *policy, *terms;
@property (strong, nonatomic) IBOutlet UIButton *editNameButton, *resetPasswordButton, *editEmailButton, *logoutButton, *addFriendButtonRight, *destHome, *destSettings;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet NSMutableArray *adjectiveArray;
@property NSString *fname, *lname;

@end

@implementation SettingsViewController

const int INDENT = 20;
const int CHAR_WIDTH = 10;
const int TEXT_SPACING = 4;

- (id)initWithNibName:(NSString *)nibNameOrNil
			   bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
						   bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)switchViews:(BOOL)showSettings
{
	/*
     if([MyManagedObjectContext isThisUserHungry]) {
     [self.destHome setEnabled:false];
     [self.destHome setHidden:true];
     
     [self.destSettings setEnabled:false];
     [self.destSettings setHidden:true];
     [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:true];
     } else {
     [self.destHome setEnabled:true];
     [self.destHome setHidden:false];
     
     [self.destSettings setEnabled:true];
     [self.destSettings setHidden:false];
     if(showSettings) {
     // show settings
     [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:true];
     } else {
     // show home
     [self.scrollView setContentOffset:CGPointMake(0, 0) animated:true];
     }
     }
     
     [self.destHome setNeedsDisplay];
     [self.destSettings setNeedsDisplay];
	 */
}


- (IBAction)unwindFromEditScreen:(UIStoryboardSegue *)segue
{
	UIAlertView *message;
	NSString *errorMessage;
    
    NSString *sessionid =[MyManagedObjectContext token];
    
	EditSettingsViewController *edit = (EditSettingsViewController *)segue.sourceViewController;
	NSString *tempProp1 = [edit.property1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *sentTempProp1 = [edit.property1 stringByReplacingOccurrencesOfString:@" " withString:@"!!_____!_____!!"];
	NSString *tempProp2 = [edit.property2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *sentTempProp2 = [edit.property2 stringByReplacingOccurrencesOfString:@" " withString:@"!!_____!_____!!"];
	NSString *tempProp3 = [edit.property3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if([edit.editType isEqualToString:@"editName"]) {
		if(tempProp1.length > 0 && tempProp2.length > 0) {
			self.fname = edit.property1;
			self.lname = edit.property2;
			
			self.name.text = [NSString stringWithFormat:@"%@ %@", edit.property1, edit.property2];
            
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/editnamejson.php?session=%@&fname=%@&lname=%@",sessionid, sentTempProp1, sentTempProp2]];
			NSURLRequest *request = [NSURLRequest requestWithURL:url];
			
			NSData *resData = [NSURLConnection sendSynchronousRequest:request
													returningResponse:nil
																error:nil];
			
			NSString *resString = [[NSString alloc] initWithData:resData
														encoding:NSUTF8StringEncoding];
			
			if(![resString isEqualToString:@"error: could not edit name"]) {
				message = [[UIAlertView alloc] initWithTitle:@"Edit Name Success"
													 message:@"Successful attempt to edit name."
													delegate:nil
										   cancelButtonTitle:@"Dismiss"
										   otherButtonTitles:nil];
			}
		}
		if(message == nil) errorMessage = @"edit name";
	} else if([edit.editType isEqualToString:@"resetPassword"]) {
		if([tempProp2 isEqualToString:tempProp3] && tempProp2.length > 0) {
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/editpasswordjson.php?session=%@&current=%@&new=%@", sessionid, sentTempProp1, sentTempProp2]];
			NSURLRequest *request = [NSURLRequest requestWithURL:url];
			
			NSData *resData = [NSURLConnection sendSynchronousRequest:request
													returningResponse:nil
																error:nil];
			NSString *resString = [[NSString alloc] initWithData:resData
														encoding:NSUTF8StringEncoding];
			if(![resString isEqualToString:@"error: password not updated"]) {
				message = [[UIAlertView alloc] initWithTitle:@"Password Reset"
													 message:@"Successful reset of your password."
													delegate:nil
										   cancelButtonTitle:@"Dismiss"
										   otherButtonTitles:nil];
				self.password.text = resString;
			}
		}
		if(message == nil) errorMessage = @"reset password";
	} else if([edit.editType isEqualToString:@"editEmail"]) {
		if([tempProp1 isEqualToString:tempProp2] && tempProp1.length > 0) {
			
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/editemailjson.php?session=%@&email=%@",sessionid, sentTempProp1]];
			NSURLRequest *request = [NSURLRequest requestWithURL:url];
			
			NSData *resData = [NSURLConnection sendSynchronousRequest:request
													returningResponse:nil
																error:nil];
			
			NSString *resString = [[NSString alloc] initWithData:resData
														encoding:NSUTF8StringEncoding];
			
			if(![resString isEqualToString:@"error: email not updated"]) {
				self.email.text = edit.property1;
				message = [[UIAlertView alloc] initWithTitle:@"Email Updated"
													 message:@"Successful update of your email."
													delegate:nil
										   cancelButtonTitle:@"Dismiss"
										   otherButtonTitles:nil];
			}
		}
		if(message == nil) errorMessage = @"edit email";
	}
	if(message == nil) {
		message = [[UIAlertView alloc] initWithTitle:@"Error"
											 message:[NSString stringWithFormat:@"Could not process your %@ request.\nPlease try again", errorMessage]
											delegate:nil
								   cancelButtonTitle:@"Dismiss"
								   otherButtonTitles:nil];
	}
    
	[message show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	[self.navigationController setNavigationBarHidden:false
											 animated:false];
	
	if([segue.identifier isEqualToString:@"editName"]) {
		EditSettingsViewController *edit = (EditSettingsViewController *)segue.destinationViewController;
		edit.editType = @"editName";
		edit.property1 = self.fname;
		edit.property2 = self.lname;
    } else if([segue.identifier isEqualToString:@"resetPassword"]) {
		EditSettingsViewController *edit = (EditSettingsViewController *)segue.destinationViewController;
		edit.editType = @"resetPassword";
	} else if([segue.identifier isEqualToString:@"editEmail"]) {
		EditSettingsViewController *edit = (EditSettingsViewController *)segue.destinationViewController;
		edit.editType = @"editEmail";
	} else if([segue.identifier isEqualToString:@"addFriend"]) {
		ULTFriendsList *addFriend = (ULTFriendsList *)(segue.destinationViewController);
		addFriend.originView = @"settingsPage";
	}
	
	if([segue.identifier isEqualToString:@"addFriends"]) {
		UIBarButtonItem *cancelBut = [[UIBarButtonItem alloc] initWithTitle:@"Done"
																	  style:UIBarButtonSystemItemCancel
																	 target:nil
																	 action:nil];
		[[self navigationItem] setBackBarButtonItem:cancelBut];
        
	} else {
		UIBarButtonItem *cancelBut = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
																	  style:UIBarButtonSystemItemCancel
																	 target:nil
																	 action:nil];
		[[self navigationItem] setBackBarButtonItem:cancelBut];
        
	}
}

- (void)buttonClicked:(UIButton *)button
{
	if([button.titleLabel.text isEqualToString:@"Edit Name"]) {
		[self performSegueWithIdentifier:@"editName" sender:self];
	} else if([button.titleLabel.text isEqualToString:@"Reset Password"]) {
		[self performSegueWithIdentifier:@"resetPassword" sender:self];
	} else if([button.titleLabel.text isEqualToString:@"Edit Email"]) {
		[self performSegueWithIdentifier:@"editEmail" sender:self];
	} else if([button.titleLabel.text isEqualToString:@"Add Friends"]) {
		[self performSegueWithIdentifier:@"addFriends" sender:self];
	} else if([button.titleLabel.text isEqualToString:@"Logout"]) {
        
        ULTDataViewController *ult = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
        [self presentViewController:ult animated:YES completion:^(void) {
            
            [ult unwindFromLogoutButton:nil];
            
        }];
        
		// not working anymore bc we do not instantiate the login FIRST cant unwind to a place that doesnt exist yet [self performSegueWithIdentifier:@"unwindToHome" sender:self];
	} /*else if([button.titleLabel.text isEqualToString:@"switchToSettings"]) {
       [self switchViews:0];
       } else if([button.titleLabel.text isEqualToString:@"switchToHome"]) {
       [self switchViews:1];
       }*/
}

- (void)addDetailedSettings
{
	CGFloat butSpace = 10;
	CGFloat textHeight = 21;
	CGFloat textWidth = self.view.frame.size.width - 2*INDENT;
	CGFloat scrnWidth = self.view.frame.size.width;
	scrnWidth = 0;
	
	//add friend button
	self.addFriendButtonRight = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	self.addFriendButtonRight.frame = CGRectMake(scrnWidth + 106, butSpace, 112, 44);
	[self.addFriendButtonRight setTitle:@"Add Friends"
                               forState:UIControlStateNormal];
	[self.addFriendButtonRight addTarget:self
                                  action:@selector(buttonClicked:)
                        forControlEvents:UIControlEventTouchUpInside];
	
	[self.scrollView addSubview:self.addFriendButtonRight];
	//end
	
	//first name label
	CGFloat fnameYSpace = self.addFriendButtonRight.frame.origin.y + self.addFriendButtonRight.frame.size.height + butSpace;
	self.name = [[UILabel alloc] initWithFrame:CGRectMake(scrnWidth + INDENT, fnameYSpace, textWidth, textHeight)];
	self.name.textColor = [UIColor whiteColor];
	self.name.backgroundColor = [UIColor clearColor];
	
	[self.scrollView addSubview:self.name];
	//end
	
	//add edit name button
	self.editNameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	CGFloat editNameY = fnameYSpace + self.name.frame.size.height + butSpace;
	self.editNameButton.frame = CGRectMake(scrnWidth + INDENT, editNameY, 140, 22);
	[self.editNameButton setTitle:@"Edit Name"
						 forState:UIControlStateNormal];
	[self.editNameButton addTarget:self
                            action:@selector(buttonClicked:)
                  forControlEvents:UIControlEventTouchUpInside];
	
	[self.scrollView addSubview:self.editNameButton];
	//end
	
	//add email
	CGFloat emailYSpace = editNameY + self.editNameButton.frame.size.height + butSpace;
	self.email = [[UILabel alloc] initWithFrame:CGRectMake(scrnWidth + INDENT, emailYSpace, textWidth, textHeight)];
	self.email.textColor = [UIColor whiteColor];
	self.email.backgroundColor = [UIColor clearColor];
	
	[self.scrollView addSubview:self.email];
	//end
	
	//add edit email button
	self.editEmailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	CGFloat editEmailY = emailYSpace + textHeight + butSpace;
	self.editEmailButton.frame = CGRectMake(scrnWidth + INDENT, editEmailY, 140, 22);
	[self.editEmailButton setTitle:@"Edit Email"
						  forState:UIControlStateNormal];
	[self.editEmailButton addTarget:self
                             action:@selector(buttonClicked:)
                   forControlEvents:UIControlEventTouchUpInside];
	
	[self.scrollView addSubview:self.editEmailButton];
	//end
	
	//add password
	CGFloat passwordYSpace = editEmailY + self.editEmailButton.frame.size.height + butSpace;
	self.password = [[UILabel alloc] initWithFrame:CGRectMake(scrnWidth + INDENT, passwordYSpace, textWidth, textHeight)];
	self.password.textColor = [UIColor whiteColor];
	self.password.backgroundColor = [UIColor clearColor];
	
	[self.scrollView addSubview:self.password];
	//end
	
	//add reset password button
	self.resetPasswordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	CGFloat resetPWY = passwordYSpace + textHeight + butSpace;
	self.resetPasswordButton.frame = CGRectMake(scrnWidth + INDENT, resetPWY, 140, 22);
	[self.resetPasswordButton setTitle:@"Reset Password"
							  forState:UIControlStateNormal];
	[self.resetPasswordButton addTarget:self
								 action:@selector(buttonClicked:)
					   forControlEvents:UIControlEventTouchUpInside];
	
	[self.scrollView addSubview:self.resetPasswordButton];
	//end
	
	//add privacy policy label
	CGFloat policyYSpace = self.resetPasswordButton.frame.origin.y + self.resetPasswordButton.frame.size.height + butSpace;
	//CGFloat chWidth = 9
	CGFloat textLen =  CHAR_WIDTH*[@"Privacy Policy" length];
	self.policy = [[UILabel alloc] initWithFrame:CGRectMake(scrnWidth + INDENT, policyYSpace, textLen, textHeight)];
	self.policy.textColor = [UIColor lightGrayColor];
	self.policy.backgroundColor = [UIColor clearColor];
	self.policy.text = @"Privacy Policy";
	
	[self.scrollView addSubview:self.policy];
	//end
	
	//add terms label
	textLen =  CHAR_WIDTH*[@"Terms" length];
	//CGFloat policyXPos = 2 * scrnWidth - INDENT - textLen;
	CGFloat policyXPos = self.view.frame.size.width - INDENT - textLen;
	self.terms = [[UILabel alloc] initWithFrame:CGRectMake(policyXPos, policyYSpace, textLen, textHeight)];
	self.terms.textColor = [UIColor lightGrayColor];
	self.terms.backgroundColor = [UIColor clearColor];
	self.terms.text = @"Terms";
	
	[self.scrollView addSubview:self.terms];
	//end
	
	//add logout button
	self.logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	CGFloat logoutY = policyYSpace + textHeight + butSpace;
	self.logoutButton.frame = CGRectMake(scrnWidth + INDENT, logoutY, self.view.frame.size.width - 2*INDENT, 28);
	[self.logoutButton setTitle:@"Logout"
                       forState:UIControlStateNormal];
	[self.logoutButton setTitleColor:[UIColor redColor]
							forState:UIControlStateNormal];
	[self.logoutButton setBackgroundColor:[UIColor clearColor]];
	[self.logoutButton addTarget:self
						  action:@selector(buttonClicked:)
				forControlEvents:UIControlEventTouchUpInside];
	
	[self.scrollView addSubview:self.logoutButton];
	//end
	
	/*
     //add switch to home page button
     UIImage *rightArrow = [[UIImage alloc] initWithCGImage:[UIImage imageNamed:@"arrow.png"].CGImage
     scale:0.85
     orientation:UIImageOrientationUp];
     
     self.destHome = [UIButton buttonWithType:UIButtonTypeCustom];
     [self.destHome setImage:rightArrow
     forState:UIControlStateNormal];
     [self.destHome setImage:rightArrow
     forState:UIControlEventTouchDown];
     [self.destHome setTitle:@"switchToHome"
     forState:UIControlStateNormal];
     [self.destHome setFrame:CGRectMake(self.view.frame.size.width - INDENT - 30, INDENT/3, 30, 30)];
     [self.destHome addTarget:self
     action:@selector(buttonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
     
     [self.scrollView addSubview:self.destHome];
     //end
	 */
	
	NSString *sessionid =[MyManagedObjectContext token];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/getwpuserjson.php?session=%@", sessionid]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *resData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:nil
                                                        error:nil];
    
    NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:resData
															 options:0
                                                               error:nil];
    
    
    if(userData) {
        self.fname = [userData valueForKey:@"fname"];
        self.lname = [userData valueForKey:@"lname"];
        self.name.text = [NSString stringWithFormat:@"%@ %@", self.fname, self.lname];
        self.password.text = [userData valueForKey:@"password"];
        self.email.text = [userData valueForKey:@"email"];
        
        [MyManagedObjectContext setFname:self.fname];
        [MyManagedObjectContext setLname:self.lname];
        [MyManagedObjectContext setEmail:self.email.text];
        [MyManagedObjectContext setPhoneNumber:[userData valueForKey:@"phone"]];
        [MyManagedObjectContext setEventID:[[userData valueForKey:@"chatid"] intValue]];
        [MyManagedObjectContext setFoodIcon:[[userData valueForKey:@"foodicon"] intValue]];
        
        
    } else {
        self.fname = @"unavailable";
        self.lname = @"unavailable";
        self.name.text = @"unavailable";
        self.editNameButton.enabled = false;
        self.email.text = @"unavailable";
        self.editEmailButton.enabled = false;
        self.password.text = @"unavailable";
        self.resetPasswordButton.enabled = false;
    }
}

- (void)addHomepage
{
	//add pickerView
	/*self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(INDENT, 3*INDENT, self.view.frame.size.width - 2*INDENT, 50)];
     
     self.pickerView.delegate = self;
     self.pickerView.dataSource = self;
     self.pickerView.showsSelectionIndicator = YES;
     
     self.adjectiveArray = [[NSMutableArray alloc] initWithObjects:@"Hungry", @"Exercise", @"Shop", @"Party", nil];
     
     [self.scrollView addSubview:self.pickerView];
     */
	//end
	
	//add addFriend button
	
	//end
	
	/*
     //add button to switch to detailed settings
     UIImage *leftArrow = [[UIImage alloc] initWithCGImage:[UIImage imageNamed:@"arrow.png"].CGImage
     scale:0.85
     orientation:UIImageOrientationDown];
     
     self.destSettings = [UIButton buttonWithType:UIButtonTypeCustom];
     [self.destSettings setImage:leftArrow
     forState:UIControlStateNormal];
     [self.destSettings setImage:leftArrow
     forState:UIControlEventTouchDown];
     [self.destSettings setTitle:@"switchToSettings"
     forState:UIControlStateNormal];
     [self.destSettings setFrame:CGRectMake(self.view.frame.size.width + INDENT, INDENT/3, 30, 30)];
     [self.destSettings addTarget:self
     action:@selector(buttonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
     
     [self.scrollView addSubview:self.destSettings];
     //end
	 */
}

//find actual height
- (void)addScrollView
{
	CGFloat scrollHeight = 333;
	self.scrollView = [[UIScrollView alloc] init];
	
	self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, scrollHeight);
	
	self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollHeight);
	//self.scrollView.contentSize = CGSizeMake(2*self.view.frame.size.width, scrollHeight);
    
	self.scrollView.backgroundColor = [UIColor blackColor];
    
	[self.scrollView setScrollEnabled:true];
	//[self.scrollView setScrollEnabled:false];
	
	[self.view addSubview:self.scrollView];
}

/*
 //Populates self.pickerView
 
 - (NSString*)pickerView:(UIPickerView *)pickerView
 titleForRow:(NSInteger)row forComponent:(NSInteger)component
 {
 return [self.adjectiveArray objectAtIndex:row];
 }
 
 
 // Returns the number of items in self.pickerView
 
 - (NSInteger)pickerView:(UIPickerView *)pickerView
 numberOfRowsInComponent:(NSInteger)component
 {
 return self.adjectiveArray.count;
 }
 
 
 // Returns the numbers of columns in the self.pickerView
 
 - (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
 {
 return 1;
 }
 */
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self addScrollView];
    [self addDetailedSettings];
	//[self addHomepage];
    //[self switchViews:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
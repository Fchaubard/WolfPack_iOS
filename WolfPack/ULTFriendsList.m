//
//  ULTFriendsList.m
//  UserLoginTest
//
//  Created by Rebecca Rich on 3/17/13.
//  Copyright (c) 2013 Rebecca Rich. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import "ULTFriendsList.h"
#import "MyManagedObjectContext.h"

@interface ULTFriendsList ()
@property (strong, nonatomic) NSArray *alphaCharSecArray;
@property (strong, nonatomic) NSMutableArray *wolfpackNamesList, *wolfpackSessIdsList;
@property (strong, nonatomic) NSMutableArray *wolfpackFriendStatusList, *blockedArray, *friendArray, *inviteArray;
@property (strong, nonatomic) NSMutableArray *jsonArray, *potentialArray, *pendingArray, *contactsArray;
@property NSInteger numFriendsPotential, numFriendsPending, numFriends, numBlocked;
@property (strong, nonatomic) NSMutableDictionary *buttonDictionary;

@end

@interface CustomUIButton : UIButton
@property NSString *mobile;

@end

@implementation CustomUIButton
//empty

@end

@implementation ULTFriendsList
@synthesize myTableView;
@synthesize wolfpackNamesList;
@synthesize wolfpackSessIdsList;
@synthesize wolfpackFriendStatusList;


-(IBAction)dismissModal:(id)sender{
    
    [self dismissViewControllerAnimated:TRUE completion:^(void){
       
        [self performSegueWithIdentifier:@"toTheMap" sender:self];
    }];
}

- (void)initAlphaArray
{
	if(self.alphaCharSecArray == NULL) {
		self.alphaCharSecArray = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N",
        @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"];
	}
}


#pragma mark - life cycle methods
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //custom init
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _buttonDictionary = [[NSMutableDictionary alloc] init];
    
	if([self.originView isEqualToString:@"tutorial"]) {
		self.navigationItem.hidesBackButton = YES;
	}
    
	[self getWolfpackFriendMapping];
	[self initAlphaArray];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect rect = self.tableView.frame;
    rect.size.height = rect.size.height;//-self.tabBarController.tabBar.frame.size.height;
    [self.tableView setFrame:rect];
    
}

-(void)deleteWolf:(NSString *)wolfToDelete
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *token = [MyManagedObjectContext token];
    NSLog(@"Token Found from Defaults: %@",token);
    
    
    NSString *jsonCallUrl = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/removefromwpjson.php?session=%@&friendid=%@",token,wolfToDelete]; //Not removing friend right now
    //NSLog(@"JSON Url Call String: %@",jsonCallUrl);
    NSData *dataURL =  [NSData dataWithContentsOfURL: [ NSURL URLWithString: jsonCallUrl ]];
    NSString *serverOutput = [[NSString alloc] initWithData:dataURL encoding: NSUTF8StringEncoding];
    NSLog(@"Server Output: %@",serverOutput);
    [self getWolfpackFriendMapping];
    [myTableView reloadData];
}

-(void)sortJsonArray:(NSString *)token
{
	NSString *potential = @"1", *pending = @"2", *friends = @"3", *blocked = @"4", *invite = @"5";
	
	if(self.potentialArray == NULL) {
		self.potentialArray = [NSMutableArray array];
	}
	
	if(self.pendingArray == NULL) {
		self.pendingArray = [NSMutableArray array];
	}
	
	if(self.friendArray == NULL) {
		self.friendArray = [NSMutableArray array];
	}
	
	if(self.blockedArray == NULL) {
		self.blockedArray = [NSMutableArray array];
	}
	
	if(self.inviteArray == NULL) {
		self.inviteArray = [NSMutableArray arrayWithCapacity:27];
		for(int i = 0; i < 27; i++) {
			[self.inviteArray insertObject:[NSMutableArray array] atIndex:i];
		}
	}
    
	for(NSDictionary *entry in self.jsonArray) {
		if((entry != NULL) && (![[entry valueForKey:@"friendphone"] isEqualToString:[entry valueForKey:@"myphone"]])) {
			
			NSString *friendStatus = [entry valueForKey:@"friendstatus"];
			
			if([friendStatus isEqualToString:potential]) {
				[self.potentialArray addObject:entry];
			} else if([friendStatus isEqualToString:pending]) {
				[self.pendingArray addObject:entry];
			} else if([friendStatus isEqualToString:friends]) {
				[self.friendArray addObject:entry];
			} else if([friendStatus isEqualToString:blocked]) {
				[self.blockedArray addObject:entry];
			} else if([friendStatus isEqualToString:invite]) {
				if(![[entry objectForKey:@"fname"] isEqualToString:@""]) {
					int result = [[[entry objectForKey:@"fname"] uppercaseString] UTF8String][0] - 'A';
					if(result > 25 || result < 0) {
						//A-Z = 0-25, misc = 26
						result = 26;
					}
					NSMutableArray *copy = [self.inviteArray objectAtIndex:result];
					[copy addObject:entry];
					[self.inviteArray replaceObjectAtIndex:result withObject:copy];
				}
			}
		}
	}
    
	if(self.pendingArray.count > 0) {
		NSMutableArray *tempPotentialArray = [NSMutableArray array];
		Boolean addToTempPotArray;
		for(NSDictionary *pot in self.potentialArray) {
			addToTempPotArray = true;
			NSString *potFriendPhone = [pot valueForKey:@"friendphone"];
			for(NSDictionary *pend in self.pendingArray) {
				if([[pend valueForKey:@"friendphone"] isEqualToString:potFriendPhone]) {
					addToTempPotArray = false;
				}
			}
			if(addToTempPotArray) {
				[tempPotentialArray addObject:pot];
			}
		}
		[self.potentialArray setArray:tempPotentialArray];
	}
	
	self.numFriendsPotential = self.potentialArray.count;
	self.numFriendsPending = self.pendingArray.count;
	self.numFriends = self.friendArray.count;
	self.numBlocked = self.blockedArray.count;
}

-(void)getWolfpackFriendMapping
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *token = [MyManagedObjectContext token];
	
	if(self.jsonArray == NULL) {
		self.jsonArray = [NSMutableArray array];
	}
	
	__block BOOL accessGranted = NO;
	ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
	
	if (ABAddressBookRequestAccessWithCompletion != NULL) {
		dispatch_semaphore_t sema = dispatch_semaphore_create(0);
		ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
			accessGranted = granted;
			dispatch_semaphore_signal(sema);
		});
		dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
	} else {
		accessGranted = YES;
	}
	
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	activityIndicator.center = self.view.center;
	
	
	[self.view addSubview:activityIndicator];
	[activityIndicator startAnimating];
	[self.view setNeedsDisplay];
    
	dispatch_queue_t downloadQueue = dispatch_queue_create("get Wolfpack From DB", NULL);
    dispatch_async(downloadQueue, ^{
        
		if(accessGranted) {
			
			if(self.contactsArray == NULL) {
				self.contactsArray = [NSMutableArray array];
			}
			
			CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(addressBook);
			int allCountsCount = (int)CFArrayGetCount(allContacts);
			CFMutableArrayRef allContactsMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault, allCountsCount, allContacts);
			
            CFArraySortValues(allContactsMutable, CFRangeMake(0, allCountsCount),(CFComparatorFunction) ABPersonComparePeopleByName, kABPersonSortByFirstName);
            
			ABRecordRef ref;
			NSString *fname = @"", *lname = @"", *mobileNum = @"";
			NSString *fprev = @"", *lprev = @"", *mprev = @"";
			ABMultiValueRef phoneRef;
			NSDictionary *dict;
			int mobileIncludesOne = 11;
            
			for(int i = 0; i < allCountsCount; i++) {
				ref = CFArrayGetValueAtIndex(allContactsMutable, i);
				
				fname = (__bridge NSString *)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
				lname = (__bridge NSString *)ABRecordCopyValue(ref, kABPersonLastNameProperty);
				
				if(fname == NULL) {
					fname = @"";
				}
				if(lname == NULL) {
					lname = @"";
				}
				
				phoneRef = (ABMultiValueRef)ABRecordCopyValue(ref, kABPersonPhoneProperty);
				
				if(ABMultiValueGetCount(phoneRef) > 0) {
					
					mobileNum = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneRef, 0);
					
					NSCharacterSet *remove = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
					mobileNum = [[mobileNum componentsSeparatedByCharactersInSet:remove] componentsJoinedByString:@""];
					
					if(mobileNum.length == mobileIncludesOne) {
						mobileNum = [mobileNum substringFromIndex:1];
					}
					
					dict = @{@"fname":fname, @"lname":lname, @"hidden":@"0", @"friendstatus":@"5", @"adjective":@"", @"phone":mobileNum};
					
					if([fname isEqualToString:fprev] && [lname isEqualToString:lprev] && [mobileNum isEqualToString:mprev]) {
						continue;
					}
					
					fprev = fname;
					lprev = lname;
					mprev = mobileNum;
					
					[self.contactsArray addObject:dict];
				}
			}
			
			NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/accessfriendmappingjson.php?session=%@", token]];
			
			[request setURL:url];
			[request setHTTPMethod:@"POST"];
			
			NSError *error;
			
			NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.contactsArray
															   options:NSJSONWritingPrettyPrinted
																 error:&error];
			
			[request setHTTPBody:jsonData];
			
			
			NSURLResponse *response;
			NSData *urlData = [NSURLConnection sendSynchronousRequest:request
													returningResponse:&response
																error:&error];
            
			if(urlData) {
				self.jsonArray = [NSJSONSerialization JSONObjectWithData:urlData
																 options:0
																   error:&error];
				[self sortJsonArray:token];
			}
		} else {
			NSString *settingsError = @"Wolfpack needs to access your contacts so we can find your friends.\nSettings > Privacy > Contacts > Turn On for Wolfpack";
			UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
															  message:settingsError
															 delegate:nil
													cancelButtonTitle:@"OK"
													otherButtonTitles:nil];
			[message show];
		}
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            
			[self.tableView reloadData];
        });
    });
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	//request, potential, 26 letters in the alphabet, misc
	return 29;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	int count = (section == 0) ? self.numFriendsPending : (section == 1) ? self.numFriendsPotential : (section > 1 && section < 29) ? [[self.inviteArray objectAtIndex:(section - 2)] count] : 0;
	if(count == 0) {
		return 0.01;
	} else return 22;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == 0) {
		return self.numFriendsPending;
	} else if(section == 1) {
		return self.numFriendsPotential;
	} else if(section > 1 && section < 29) {
		return [[self.inviteArray objectAtIndex:(section - 2)] count];
	} else return  0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(section == 0) {
		return (self.numFriendsPending == 0) ? nil : @"Wants to join your WolfPack";
	} else if(section == 1) {
		return (self.numFriendsPotential == 0) ? nil : @"Add to your WolfPack";
	} else if(section > 1 && section < 29) {
		return ([[self.inviteArray objectAtIndex:(section - 2)] count] == 0) ? nil : [self.alphaCharSecArray objectAtIndex:(section - 2)];
	} else return nil;
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[self dismissViewControllerAnimated:true
							 completion:nil];
	
}

- (NSString *)formatDetail:(NSString *)detail
{
	int validLen = 10;
	if([detail length] == validLen) {
		return [NSString stringWithFormat:@"(%@) %@-%@", [detail substringWithRange:NSMakeRange(0, 3)], [detail substringWithRange:NSMakeRange(3, 3)], [detail substringWithRange:NSMakeRange(6, 4)]];
	}
	return detail;
}

-(void)inviteFriend:(id)sender
{
	MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
	
	if([MFMessageComposeViewController canSendText]) {
		
		CustomUIButton *button = (CustomUIButton *)sender;
		
		NSString *number = button.mobile;
		
		controller.body = @"JOIN WOLFPACK!\nThe best way to hangout with me.\n\nhttp://tflig.ht/18Ibtb0";
		controller.recipients = [NSArray arrayWithObjects:number, nil];
		controller.messageComposeDelegate = self;
		
		[self presentViewController:controller
						   animated:true
						 completion:nil];
	}
}

-(void)approveFriend:(id)sender
{
	CustomUIButton *button = (CustomUIButton *)sender;
	
	[button setEnabled:false];
	[button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	[button setBackgroundColor:[UIColor blackColor]];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [prefs stringForKey:@"token"];
	
	NSString *number = button.mobile;
    
    NSString *urlText = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/respondtowprequestjson.php?session=%@&response=3&friendid=%@", token, number];
	
	dispatch_queue_t downloadQueue = dispatch_queue_create("approve - update Friend Status", NULL);
    dispatch_async(downloadQueue, ^{
        
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlText]];
		
		NSData *resData = [NSURLConnection sendSynchronousRequest:request
												returningResponse:nil
															error:nil];
		
		if(!resData) {
			NSLog(@"error in approving friend");
		} else {
			[self.pendingArray removeObjectAtIndex:button.tag];
			self.numFriendsPending--;
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

-(void)addFriend:(id)sender
{
	CustomUIButton *button = (CustomUIButton *)sender;
	[button setEnabled:false];
	[button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	[button setBackgroundColor:[UIColor blackColor]];
	
    dispatch_queue_t fetchQ = dispatch_queue_create("add - Update Friend Status", NULL);
    dispatch_async(fetchQ, ^{
        
        NSString *sessionid =[[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
        
        NSString *str = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/addtowpjson.php?session=%@&friendid=%@", sessionid, button.mobile];
        
        NSURL *URL = [NSURL URLWithString:str];
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request
													 returningResponse:nil
																 error:nil];
		if(!responseData) {
			NSLog(@"error in add friend");
		} else {
			[self.potentialArray removeObjectAtIndex:[button tag]];
			self.numFriendsPotential--;
		}
        dispatch_async(dispatch_get_main_queue(), ^{
			[self.tableView reloadData];
		});
	});
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *sideLabels = [NSMutableArray array];
	if(self.numFriendsPending != 0) {
		[sideLabels addObject:@"+"];
	}
	if(self.numFriendsPotential != 0) {
		[sideLabels addObject:@"?"];
	}
	[sideLabels addObjectsFromArray:self.alphaCharSecArray];
	
	return sideLabels;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	NSString *fname = @"", *lname = @"", *detail = @"";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
															forIndexPath:indexPath];
    
    
        
	//[cell setBounds:CGRectMake(0, 0, self.view.frame.size.width, 44)];
	
    //if (![self.buttonDictionary objectForKey:[NSString stringWithFormat:@"%d %d",indexPath.section,indexPath.row]]) {
    
	CustomUIButton *button = [[CustomUIButton alloc] initWithFrame:CGRectMake(220.0f, 5.0f, 62.0f, 33.0f)];
    
	[button.layer setCornerRadius:5];
	int section = [indexPath section];
	
	if(section == 0) {
		fname = [[self.pendingArray objectAtIndex:[indexPath row]] objectForKey:@"fname"];
		lname = [[self.pendingArray objectAtIndex:[indexPath row]] objectForKey:@"lname"];
		
		[button setTitle:@"Approve"
				forState:UIControlStateNormal];
		
		[button addTarget:self
				   action:@selector(approveFriend:)
		 forControlEvents:UIControlEventTouchUpInside];
        
		button.mobile = [[self.pendingArray objectAtIndex:[indexPath row]] objectForKey:@"friendphone"];
		
		detail = [[self.pendingArray objectAtIndex:[indexPath row]] objectForKey:@"status"];
		
		[button setTag:[indexPath row]];
	} else if(section == 1) {
		fname = [[self.potentialArray objectAtIndex:[indexPath row]] objectForKey:@"fname"];
		lname = [[self.potentialArray objectAtIndex:[indexPath row]] objectForKey:@"lname"];
		
		[button setTitle:@"Add"
				forState:UIControlStateNormal];
		
		[button addTarget:self
				   action:@selector(addFriend:)
		 forControlEvents:UIControlEventTouchUpInside];
		
		button.mobile = [[self.potentialArray objectAtIndex:[indexPath row]] objectForKey:@"friendphone"];
		
		detail = [[self.potentialArray objectAtIndex:[indexPath row]] objectForKey:@"status"];
		
		[button setTag:[indexPath row]];
	} else if(section > 1 && section < 29) {
		fname = [[[self.inviteArray objectAtIndex:([indexPath section] - 2)] objectAtIndex:[indexPath row]] objectForKey:@"fname"];
		lname = [[[self.inviteArray objectAtIndex:([indexPath section] - 2)] objectAtIndex:[indexPath row]] objectForKey:@"lname"];
		
		[button setTitle:@"Invite"
				forState:UIControlStateNormal];
        
		[button addTarget:self
				   action:@selector(inviteFriend:)
		 forControlEvents:UIControlEventTouchUpInside];
		
		detail = [[[self.inviteArray objectAtIndex:([indexPath section] - 2)] objectAtIndex:[indexPath row]] objectForKey:@"friendphone"];
        
		button.mobile = detail;
        
		detail = [self formatDetail:detail];
	}
	
	[button setBackgroundColor:[UIColor lightGrayColor]];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont systemFontOfSize:15]];
	//if (cell==nil) {
    //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        [self.buttonDictionary setValue:button forKey:[NSString stringWithFormat:@"%d %d",indexPath.section,indexPath.row]];
        [cell addSubview:button];
        
    //}
        //[cell addSubview:(UIButton *)[self.buttonDictionary objectForKey:[NSString stringWithFormat:@"%d %d",indexPath.section,indexPath.row]]];
    
    
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", fname, lname]];
    
    if(detail == (NSString *)[NSNull null]) detail = @"WOLF WOLF WOLFPACK";
    
    [cell.detailTextLabel setText:detail];
    
    //}
    
	return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([indexPath section] == 0) return true;
	return false;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @" Deny ";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
		NSString *number = [[self.pendingArray objectAtIndex:[indexPath row]] valueForKey:@"friendphone"];
		
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSString *token = [MyManagedObjectContext token];
		
		NSString *urlText = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/respondtowprequestjson.php?session=%@&response=1&friendid=%@", token, number];
        
		dispatch_queue_t downloadQueue = dispatch_queue_create("Deny Friend Request", NULL);
		dispatch_async(downloadQueue, ^{
			
			NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlText]];
			
			NSData *resData = [NSURLConnection sendSynchronousRequest:request
													returningResponse:nil
																error:nil];
			if(!resData) {
				NSLog(@"error in deny friend request");
			} else {
				NSDictionary *denied = [self.pendingArray objectAtIndex:[indexPath row]];
				
				[self.pendingArray removeObjectAtIndex:[indexPath row]];
				self.numFriendsPending--;
				
				[self.potentialArray addObject:denied];
				self.numFriendsPotential++;
			}
			
			dispatch_async(dispatch_get_main_queue(), ^{
				[tableView reloadData];
			});
		});
	} else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

@end

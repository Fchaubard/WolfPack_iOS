//
//  ULTFriendsList.m
//  UserLoginTest
//
//  Created by Rebecca Rich on 3/17/13.
//  Copyright (c) 2013 Rebecca Rich. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import "ULTFriendsList.h"

@interface ULTFriendsList ()
@property (strong, nonatomic) NSMutableArray *wolfpackNamesList, *wolfpackSessIdsList;
@property (strong, nonatomic) NSMutableArray *wolfpackFriendStatusList, *blockedArray, *friendArray, *inviteArray;
@property (strong, nonatomic) NSMutableArray *jsonArray, *potentialArray, *pendingArray, *contactsArray, *alphaArray;
@property NSInteger numFriendsPotential, numFriendsPending, numFriends, numBlocked, numFriendsInvite;
@end

@implementation ULTFriendsList
@synthesize myTableView;
@synthesize wolfpackNamesList;
@synthesize wolfpackSessIdsList;
@synthesize wolfpackFriendStatusList;

-(void)deleteWolf:(NSString *)wolfToDelete
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *token = [prefs stringForKey:@"token"];
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
		self.inviteArray = [NSMutableArray array];
	}
	
	if(self.alphaArray == NULL) {
		self.alphaArray = [NSMutableArray arrayWithCapacity:26];
		for(int i = 0; i < 26; i++) {
			[self.alphaArray insertObject:[NSNumber numberWithInt:0] atIndex:i];
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
				NSLog(@"potential: %@", entry);
				[self.inviteArray addObject:entry];
			} else NSLog(@"didn't find a spot: %@", entry);
		}
	}
	
	
	if(self.pendingArray.count > 0) {
		NSMutableArray *tempPotentialArray = [NSMutableArray array];
		
		for(NSDictionary *pending in self.pendingArray) {
			NSString *pendNumber = [pending valueForKey:@"friendphone"];
			for(NSDictionary *potential in self.potentialArray) {
				NSString *potNumber = [potential valueForKey:@"friendphone"];
				if(![pendNumber isEqualToString:potNumber]) {
					[tempPotentialArray addObject:potential];
				}
			}
		}
		
		[self.potentialArray setArray:tempPotentialArray];
	}
	
	self.numFriendsPotential = self.potentialArray.count;
	self.numFriendsPending = self.pendingArray.count;
	self.numFriends = self.friendArray.count;
	self.numBlocked = self.blockedArray.count;
	self.numFriendsInvite = self.inviteArray.count;
}

-(void)getWolfpackFriendMapping
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *token = [prefs stringForKey:@"token"];
	
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
            
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/accessfriendmappingjson.php?session=%@&type=0", token]];
			
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
    [self getWolfpackFriendMapping];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	int count = (section == 0) ? self.numFriendsPending : (section == 1) ? self.numFriendsPotential : (section == 2) ? self.numFriendsInvite : 0;
	if(count == 0) {
		return 0;
	} else return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == 0) {
		return self.numFriendsPending;
	} else if(section == 1) {
		return self.numFriendsPotential;
	} else if(section == 2) {
		return self.numFriendsInvite;
	} else return  0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(section == 0) {
		return @"Wants to join your WolfPack";
	} else if(section == 1) {
		return @"Add to your WolfPack";
	} else if(section == 2) {
		return @"Invite to join WolfPack";
	} else return @"";
}

- (NSString *)formatDetail:(NSString *)detail
{
	int validLen = 10;
	if([detail length] == validLen) {
		return [NSString stringWithFormat:@"(%@) %@-%@", [detail substringWithRange:NSMakeRange(0, 3)], [detail substringWithRange:NSMakeRange(3, 3)], [detail substringWithRange:NSMakeRange(6, 4)]];
	}
	return detail;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	NSString *fname = @"", *lname = @"", *detail = @"";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
															forIndexPath:indexPath];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(251.5f, 5.0f, 63.0f, 34.0f);
	int section = [indexPath section];
	if(section == 0) {
		fname = [[self.pendingArray objectAtIndex:[indexPath row]] objectForKey:@"fname"];
		lname = [[self.pendingArray objectAtIndex:[indexPath row]] objectForKey:@"lname"];
		[button setTitle:@"Approve"
				forState:UIControlStateNormal];
		[button addTarget:self
				   action:@selector(approveFriend:)
		 forControlEvents:UIControlEventTouchUpInside];
		detail = [[self.pendingArray objectAtIndex:[indexPath row]] objectForKey:@"status"];
	} else if(section == 1) {
		fname = [[self.potentialArray objectAtIndex:[indexPath row]] objectForKey:@"fname"];
		lname = [[self.potentialArray objectAtIndex:[indexPath row]] objectForKey:@"lname"];
		[button setTitle:@"Add"
				forState:UIControlStateNormal];
		[button addTarget:self
				   action:@selector(addFriend:)
		 forControlEvents:UIControlEventTouchUpInside];
		detail = [[self.potentialArray objectAtIndex:[indexPath row]] objectForKey:@"status"];
	} else if(section == 2) {
		fname = [[self.inviteArray objectAtIndex:[indexPath row]] objectForKey:@"fname"];
		lname = [[self.inviteArray objectAtIndex:[indexPath row]] objectForKey:@"lname"];
		[button setTitle:@"Invite"
				forState:UIControlStateNormal];
		[button addTarget:self
				   action:@selector(inviteFriend:)
		 forControlEvents:UIControlEventTouchUpInside];
		detail = [[self.inviteArray objectAtIndex:[indexPath row]] objectForKey:@"friendphone"];
		detail = [self formatDetail:detail];
	}
	
	[button.titleLabel setFont:[UIFont systemFontOfSize:15]];
	[button setTag:[indexPath row]];
	[cell addSubview:button];
	
	[cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", fname, lname]];
	if(detail == (NSString *)[NSNull null]) detail = @"WOLF WOLF WOLFPACK";
	[cell.detailTextLabel setText:detail];
	
	return cell;
}

-(void)inviteFriend:(id)sender
{
	MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
	
	if([MFMessageComposeViewController canSendText]) {
		
		UIButton *button = (UIButton *)sender;
		
		NSString *number = [[self.inviteArray objectAtIndex:button.tag] valueForKey:@"friendphone"];
		
		controller.body = @"JOIN WOLFPACK!";
		controller.recipients = [NSArray arrayWithObjects:number, nil];
		controller.messageComposeDelegate = self;
		
		[self presentViewController:controller
						   animated:true
						 completion:nil];
	}
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[self dismissViewControllerAnimated:true
							 completion:nil];
	
}

-(void)approveFriend:(id)sender
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [prefs stringForKey:@"token"];
	
	UIButton *button = (UIButton *)sender;
	NSString *number = [[self.pendingArray objectAtIndex:button.tag] valueForKey:@"friendphone"];
	
    
    NSString *urlText = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/respondtowprequestjson.php?session=%@&response=3&friendid=%@", token, number];
	
	dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
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
    [sender setTitle:@"Adding"
            forState:UIControlStateNormal];
    dispatch_queue_t fetchQ = dispatch_queue_create("Update Friend Status", NULL);
    dispatch_async(fetchQ, ^{
        
        NSString *sessionid =[[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
        
        NSString *str = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/addtowpjson.php?session=%@&friendid=%@", sessionid, [[self.potentialArray objectAtIndex: [(UIButton *)sender tag]] objectForKey:@"friendphone"]];
        
        NSURL *URL = [NSURL URLWithString:str];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request
													 returningResponse:nil
																 error:nil];
        if(!responseData) {
			NSLog(@"error in add friend");
		} else {
			[self.potentialArray removeObjectAtIndex:[(UIButton *)sender tag]];
			self.numFriendsPotential--;
		}
        dispatch_async(dispatch_get_main_queue(), ^{
            [sender setTitle:@"Added"
                    forState:UIControlStateNormal];
			[self.tableView reloadData];
		});
	});
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
		NSString *token = [prefs stringForKey:@"token"];
		
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

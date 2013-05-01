//
//  ULTFriendsList.m
//  UserLoginTest
//
//  Created by Rebecca Rich on 3/17/13.
//  Copyright (c) 2013 Rebecca Rich. All rights reserved.
//

#import "ULTFriendsList.h"

@interface ULTFriendsList ()
@property (strong, nonatomic) NSMutableArray *wolfpackNamesList;
@property (strong, nonatomic) NSMutableArray *wolfpackSessIdsList;
@property (strong, nonatomic) NSMutableArray *wolfpackFriendStatusList;
@property (strong, nonatomic) NSArray *jsonArray;

@end

@implementation ULTFriendsList
@synthesize myTableView;
@synthesize wolfpackNamesList;
@synthesize wolfpackSessIdsList;
@synthesize wolfpackFriendStatusList;

-(void) deleteWolf:(NSString *) wolfToDelete
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *token = [prefs stringForKey:@"token"];
    NSLog(@"Token Found from Defaults: %@",token);
    
    
    NSString *jsonCallUrl = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/removefromwpjson.php?session=%@&friendid=%@",token,wolfToDelete]; //Not removing friend right now
    NSLog(@"JSON Url Call String: %@",jsonCallUrl);
    NSData *dataURL =  [NSData dataWithContentsOfURL: [ NSURL URLWithString: jsonCallUrl ]];
    NSString *serverOutput = [[NSString alloc] initWithData:dataURL encoding: NSUTF8StringEncoding];
    NSLog(@"Server Output: %@",serverOutput);
    [self getWolfpackFromDB];
    [myTableView reloadData];
}

-(void) getWolfpackFromDB
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *token = [prefs stringForKey:@"token"];
    NSLog(@"Token Found from Defaults: %@",token);
    
    
    if(self.jsonArray == NULL){
        self.jsonArray = [[NSArray alloc] init];
    }
 
    
    NSString *urlText = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/getalljson.php?session=%@",token];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	activityIndicator.center = self.view.center;
	[self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
    [self.view setNeedsDisplay];
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        
        NSError *e = nil;
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:urlText]];
        NSLog(@"Data: %@",data);
        self.jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
        if (!self.jsonArray) {
            NSLog(@"Error parsing JSON: %@", e);
        } else {
            for(NSDictionary *item in self.jsonArray) {
                NSLog(@"Item: %@", item);
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            [self.tableView reloadData];
        });
    });
      
    //NSString *post = [NSString stringWithFormat:@"username=%@",@"rebecca"]; //**FIX**
    //NSString *hostStr = @"http://www.hungrylikethewolves.com/wolfpackListCheck.php?";
    //hostStr = [hostStr stringByAppendingString:post];
    //NSLog(@"Host String: %@",hostStr);
    //NSData *dataURL =  [NSData dataWithContentsOfURL: [ NSURL URLWithString: hostStr ]];
    //NSString *serverOutput = [[NSString alloc] initWithData:dataURL encoding: NSUTF8StringEncoding];
    //NSLog(@"Server Output: %@",serverOutput);
    //wolfpacklistarray = [serverOutput componentsSeparatedByString:@","];
    //NSLog(@"Array: %@",wolfpacklistarray);
    
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
    NSLog(@"View Did Load is Called");
    [super viewDidLoad];
    [self getWolfpackFromDB];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    return [self.jsonArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSArray *updatedFriendsList = [self getWolfpackFromDB];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addButton.frame = CGRectMake(250.0f, 5.0f, 60.0f, 30.0f);
    if ([[self.jsonArray objectAtIndex:[indexPath row]] objectForKey:@"friendstatus"]==@(-1))
    {
        [addButton setTitle:@"Add" forState:UIControlStateNormal];
    }
    else{
        [addButton setTitle:@"Added" forState:UIControlStateNormal];
        [addButton setEnabled:FALSE];
    }
    addButton.tag = [indexPath row];
    [addButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:addButton];
    // Configure the cell...[fname stringByAppendingString:lname];
    cell.textLabel.text = [[[self.jsonArray
                            objectAtIndex: [indexPath row]]
                            objectForKey:@"fname"]
                           stringByAppendingString:
                           [[self.jsonArray
                             objectAtIndex: [indexPath row]]
                            objectForKey:@"lname"]];
    
    return cell;
}
- (void) addFriend:(id)sender{
    
    dispatch_queue_t fetchQ = dispatch_queue_create("Update Friend Status", NULL);
    dispatch_async(fetchQ, ^{
        
        NSString *sessionid =[[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
        [(UIButton *)sender setTitle:@"adding.." forState:UIControlStateNormal];
        [(UIButton *)sender  setEnabled:FALSE];
        
        [sender setNeedsDisplay];
        NSString *str = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/addtowpjson.php?session=%@&friendid=%@",sessionid,[[self.jsonArray objectAtIndex: [(UIButton *)sender tag]] objectForKey:@"phone"]];
        
        
        NSLog(@"%@",str);
        
        
        NSURL *URL = [NSURL URLWithString:str];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        NSError *error = [[NSError alloc] init];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSString * string = [[NSString alloc] initWithData:responseData encoding:
                             NSASCIIStringEncoding];
        
        if (string.intValue == 1) {
            NSLog(@"asdfa");
        } else {
            NSLog(@"error");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [(UIButton *)sender setTitle:@"added!" forState:UIControlStateNormal];
            [(UIButton *)sender  setEnabled:FALSE];
            [[self.jsonArray objectAtIndex:[(UIButton *)sender tag]] setObject:@1 forKey:@"friendstatus"];
        });
    });

}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source:
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *sessIdToDelete = [[self.jsonArray objectAtIndex:indexPath.row] objectForKey:@"phone"];
        [self deleteWolf:sessIdToDelete];
        //Old Approach:
        //NSString *str = cell.textLabel.text;
        //[self deleteWolf:str];
        ////[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

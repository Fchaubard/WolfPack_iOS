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
@end

@implementation ULTFriendsList
@synthesize myTableView;
@synthesize wolfpackNamesList;
@synthesize wolfpackSessIdsList;


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
    
    if(self.wolfpackNamesList == NULL){
        self.wolfpackNamesList = [[NSMutableArray alloc] init];
    }
    else{
        [self.wolfpackNamesList removeAllObjects];
    }
    if(self.wolfpackSessIdsList == NULL){
        self.wolfpackSessIdsList = [[NSMutableArray alloc] init];
    }
    else{
        [self.wolfpackSessIdsList removeAllObjects];
    }
    NSLog(@"Names Array: %@",self.wolfpackNamesList);
    NSLog(@"Sess Ids Array: %@",self.wolfpackSessIdsList);
    NSError *e = nil;
    NSString *urlText = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/getmywolfpackjson.php?session=%@",token];
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:urlText]];
    NSLog(@"Data: %@",data);
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
   
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", e);
    } else {
        for(NSDictionary *item in jsonArray) {
            NSLog(@"Item: %@", item);
            NSString *fname = [item objectForKey:@"fname"];
            NSString *lname = [item objectForKey:@"lname"];
            NSLog(@"fname: %@",fname);
            NSLog(@"lname: %@",lname);
            NSString *sessId = [item objectForKey:@"sessid"];
            NSLog(@"sessId: %@",sessId);
            NSString *friendName = [fname stringByAppendingString:lname];
            NSLog(@"friendName: %@",friendName);
            [wolfpackNamesList addObject:friendName];
            [wolfpackSessIdsList addObject:sessId];
            NSLog(@"Wolfpack Names: %@",wolfpackNamesList);
            NSLog(@"Wolfpack Session Ids: %@", wolfpackSessIdsList);
        }
    }
    
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
    
    return [wolfpackNamesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSArray *updatedFriendsList = [self getWolfpackFromDB];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [wolfpackNamesList
                           objectAtIndex: [indexPath row]];
    return cell;
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
        NSString *sessIdToDelete = [self.wolfpackSessIdsList objectAtIndex:indexPath.row];
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

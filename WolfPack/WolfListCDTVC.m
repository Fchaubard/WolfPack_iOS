//
//  WolfListCDTVC.m
//  WolfPack
//
//  Created by Francois Chaubard on 3/1/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "WolfListCDTVC.h"
#import "MyManagedObjectContext.h"
#import "Friend+MKAnnotation.h"
#import "PhonyFriendDictionary.h"

@interface WolfListCDTVC ()

@end

@implementation WolfListCDTVC

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
    [self.refreshControl addTarget:self
                            action:@selector(loadLatestFriendsData)
                  forControlEvents:UIControlEventValueChanged];
    [super viewDidLoad];
    [self reload];
    
}




- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = nil; // all Photographers
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}




- (void)reload
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    // request.predicate = [NSPredicate predicateWithFormat:@"eventID "];
    NSArray *friends = [self.managedObjectContext executeFetchRequest:request error:NULL];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) [MyManagedObjectContext returnMyManagedObjectContext:^(UIManagedDocument *doc, BOOL created) {
        self.managedObjectContext = [doc managedObjectContext];
    }];
}




-(IBAction)loadLatestFriendsData
{
    
    
    // start the animation if it's not already going
    [self.refreshControl beginRefreshing];
    
    [self getFriendData];

    [self.refreshControl endRefreshing];  // stop the animation
    [self.tableView reloadData];
    
}




-(void)getFriendData
{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES; // bad
    dispatch_queue_t loaderQ = dispatch_queue_create("latest loader", NULL);
    dispatch_async(loaderQ, ^{
        
        // call server
        // fake for now
        //NSArray *friends = [FlickrFetcher stanfordPhotos];
        NSArray *friends = [PhonyFriendDictionary returnPhonyFriendDictionary];
        
        // when we have the results, use main queue to display them
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            // populate the database
            [self.managedObjectContext performBlock:^{
                for (NSDictionary *friendDictionary in friends) {
                    [Friend friendWithData:friendDictionary inManagedObjectContext:self.managedObjectContext];
                }
            }];
            
            
        });
    });
    
}

#pragma mark - UITableViewDataSource

// Uses NSFetchedResultsController's objectAtIndexPath: to find the Photographer for this row in the table.
// Then uses that Photographer to set the cell up.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    Friend *friend = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = friend.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f latitude %f longitude %@ status", friend.latitude.doubleValue, friend.longitude.doubleValue, friend.status];
    
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

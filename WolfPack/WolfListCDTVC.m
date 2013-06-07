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

@property (nonatomic) BOOL adjMode;

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
    self.adjMode = TRUE;
    [self reload];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadLatestFriendsData];
    
}


// original
/*
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
*/
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext

{
    
    _managedObjectContext = managedObjectContext;
    
    if (managedObjectContext) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
        
        if(self.adjMode){
            
            NSSortDescriptor *statusDescriptor = [[NSSortDescriptor alloc] initWithKey:@"hungry" ascending:YES];
            
            //NSSortDescriptor *statusDescriptor = [[NSSortDescriptor alloc] initWithKey:@"hungry" ascending:YES selector:@selector(compareHungry:)];
            
            
            
            //Blocks are not allowed:
            
            
            
            /*NSSortDescriptor *statusDescriptor = [[NSSortDescriptor alloc] initWithKey:@"hungry" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
             
             NSString *oneHungry = (NSString *)obj1;
             
             NSString *toAnotherHungry = (NSString *)obj2;
             
             NSString *specialHungry = @"2";
             
             if([oneHungry isEqualToString: specialHungry]){
             
             return NSOrderedAscending;
             
             }
             
             else if ([toAnotherHungry isEqualToString: specialHungry]){
             
             return NSOrderedDescending;
             
             }
             
             else if ([oneHungry intValue]>[toAnotherHungry intValue]){
             
             return NSOrderedDescending;
             
             }
             
             else if ([oneHungry intValue]<[toAnotherHungry intValue]){
             
             return NSOrderedAscending;
             
             }
             
             else{
             
             return NSOrderedSame;
             
             }
             
             }];*/
            
            NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
            
            [request setSortDescriptors:@[statusDescriptor, nameDescriptor]];
            
            request.predicate = nil;
            
            self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:@"hungry" cacheName:nil];
            
        }
        
        else{
            
            NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
            
            [request setSortDescriptors:@[nameDescriptor]];
            
            request.predicate = nil;
            
            self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
            
        }
        
        
        
    } else {
        
        self.fetchedResultsController = nil;
        
    }
    
}

-(void)changeMode:(int)mode{
    
    if(mode==0){
        
        self.adjMode = FALSE;
        
    }
    
    else{
        
        self.adjMode = TRUE;
        
    }
    
}



- (void)reload
{
    
    //NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    // request.predicate = [NSPredicate predicateWithFormat:@"eventID "];
    //NSArray *friends = [self.managedObjectContext executeFetchRequest:request error:NULL];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
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
        //NSArray *friends = [PhonyFriendDictionary returnPhonyFriendDictionary];
        
        
        NSArray *friends = [MyManagedObjectContext pullWolfData];
        
        // when we have the results, use main queue to display them
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            // populate the database
            [self.managedObjectContext performBlock:^{
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
                NSArray *oldfriends = [self.managedObjectContext executeFetchRequest:request error:NULL];
                for (Friend* friend in oldfriends) {
                    [self.managedObjectContext deleteObject:friend];
                }
                //populate it with new ones
                for (NSDictionary *friend in friends) {
                    [Friend friendWithData:friend inManagedObjectContext:self.managedObjectContext];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return 0;//(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  WolfMapViewController.m
//  WolfPack
//
//  Created by Francois Chaubard on 3/1/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "WolfMapViewController.h"
#import "Friend+MKAnnotation.h"
#import "MyManagedObjectContext.h"
#import "PhonyFriendDictionary.h"

@interface WolfMapViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@end

@implementation WolfMapViewController


// if we are visible and our Model is (re)set, refetch from Core Data

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (self.view.window) [self reload];
    [self updateRegion]; // always update region
  //  if (self.needUpdateRegion) [self updateRegion];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refresh];
}


- (void)reload
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
   // request.predicate = [NSPredicate predicateWithFormat:@"eventID "];
    NSArray *friends = [self.managedObjectContext executeFetchRequest:request error:NULL];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:friends];

   
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
   // [self performSegueWithIdentifier:@"setPhoto:" sender:view];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"setPhoto:"]) {
        if ([sender isKindOfClass:[MKAnnotationView class]]) {
            MKAnnotationView *aView = sender;
            if ([aView.annotation isKindOfClass:[Friend class]]) {
                Friend *friend = aView.annotation;
                if ([segue.destinationViewController respondsToSelector:@selector(setFriend:)]) {
                    [segue.destinationViewController performSelector:@selector(setPhoto:) withObject:photo];
                }
            }
        }
    }
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) [MyManagedObjectContext returnMyManagedObjectContext:^(UIManagedDocument *doc, BOOL created) {
        self.managedObjectContext = [doc managedObjectContext];
    }];
    
    [self.activity setHidden:TRUE];
    [self reload];
}



//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

- (IBAction)refresh
{
    [self.activity setHidden:FALSE];
    [self.activity startAnimating];
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);
    dispatch_async(fetchQ, ^{
        
        NSArray *friends = [PhonyFriendDictionary returnPhonyFriendDictionary];
        // put the photos in Core Data
        [self.managedObjectContext performBlock:^{
            //delete old friends from core data
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
            NSArray *oldfriends = [self.managedObjectContext executeFetchRequest:request error:NULL];
            for (Friend* friend in oldfriends) {
                    [self.managedObjectContext deleteObject:friend];
            }
            //populate it with new ones
            for (NSDictionary *friend in friends) {
                [Friend friendWithData:friend inManagedObjectContext:self.managedObjectContext];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reload];
                [self.activity stopAnimating];
                [self.activity setHidden:TRUE];
            });
        }];
    });
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return 0;//(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


@end

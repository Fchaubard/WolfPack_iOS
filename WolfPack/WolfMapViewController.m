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
#import "SVProgressHUD.h"
@interface WolfMapViewController ()

@end

@implementation WolfMapViewController


// if we are visible and our Model is (re)set, refetch from Core Data

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([MyManagedObjectContext isThisUserHungry]) {
        [self getOutOfHideMode];
    }
    else{
        [self hideMode];
        
    }
    
    if (!self.managedObjectContext) [MyManagedObjectContext returnMyManagedObjectContext:^(UIManagedDocument *doc, BOOL created) {
        self.managedObjectContext = [doc managedObjectContext];
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self refresh];
            [SVProgressHUD dismiss];
        });

        
        
    }];
    
}


- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (self.view.window) [self reload];
    [self updateRegion:@1]; // always update region
  //  if (self.needUpdateRegion) [self updateRegion];
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
    
    
    [self refreshWithoutHUD];
}


-(void)refreshWithoutHUD{
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);
    dispatch_async(fetchQ, ^{
        
        //NSArray *friends = [PhonyFriendDictionary returnPhonyFriendDictionary];
        NSArray *friends = [MyManagedObjectContext pullWolfData];
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
                [SVProgressHUD dismiss];
                
            });
        }];
    });

}
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

-(void)hideMode{

    
    [self.mapView setHidden:true];
    [self.refreshButton setHidden:true];
    [self.viewWolfPackButton setHidden:true];
    [self.viewCurrentLocationButton setHidden:true];
    
    [self.refreshButton setAlpha:0.0];
    [self.viewWolfPackButton setAlpha:0.0];
    [self.viewCurrentLocationButton setAlpha:0.0];
    
    self.mapView.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.mapView.alpha = 0.0;
    }];
}

-(void)getOutOfHideMode{
    [self.mapView setHidden:false];
    [self.refreshButton setHidden:false];
    [self.viewWolfPackButton setHidden:false];
    [self.viewCurrentLocationButton setHidden:false];
    
    [self.refreshButton setAlpha:1.0];
    [self.viewWolfPackButton setAlpha:1.0];
    [self.viewCurrentLocationButton setAlpha:1.0];
    
    self.mapView.alpha = 0.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.mapView.alpha = 1.0;
    }];
}


- (IBAction)viewWolfPack{
    [self updateRegion:@1];
}

- (IBAction)viewCurrentLocation{
    [self updateRegion:@2];
}

- (IBAction)refresh
{
  
    
    if ([MyManagedObjectContext isThisUserHungry]) {
    
        [SVProgressHUD showWithStatus:@"Fetching your Hungry Wolves..."];
    
        [self refreshWithoutHUD];
            
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return 0;//(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


@end

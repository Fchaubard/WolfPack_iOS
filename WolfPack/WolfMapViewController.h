//
//  WolfMapViewController.h
//  WolfPack
//
//  Created by Francois Chaubard on 3/1/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "MapViewController.h"

@interface WolfMapViewController : MapViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UIButton *refreshButton;
@property (strong, nonatomic) IBOutlet UIButton *viewWolfPackButton;
@property (strong, nonatomic) IBOutlet UIButton *viewCurrentLocationButton;


-(void)reload;
-(void)hideMode;
-(void)getOutOfHideMode;

@end

//
//  MyCLLocationManager.m
//  WolfPack
//
//  Created by Francois Chaubard on 4/21/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "MyCLLocationManager.h"

@interface MyCLLocationManager()


@end
@implementation MyCLLocationManager


- (id)init {
    self = [super init];
    
    if(self) {
        self.locationManager = [CLLocationManager new];
        [self.locationManager setDelegate:self];
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager setHeadingFilter:kCLHeadingFilterNone];
        [self.locationManager startUpdatingLocation];
        //do any more customization to your location manager
    }
    
    return self;
}

+ (MyCLLocationManager*)sharedSingleton {
    static MyCLLocationManager* sharedSingleton;
    if(!sharedSingleton) {
        @synchronized(sharedSingleton) {
            sharedSingleton = [MyCLLocationManager new];
        }
    }
    
    return sharedSingleton;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //handle your location updates here
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    //handle your heading updates here- I would suggest only handling the nth update, because they
    //come in fast and furious and it takes a lot of processing power to handle all of them
}

@end
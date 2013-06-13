//
//  MyCLLocationManager.h
//  WolfPack
//
//  Created by Francois Chaubard on 4/21/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
@interface MyCLLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;

+ (MyCLLocationManager*)sharedSingleton;

@end

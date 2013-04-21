//
//  PhonyFriendDictionary.m
//  WolfPack
//
//  Created by Francois Chaubard on 3/4/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "PhonyFriendDictionary.h"
#import "Friend+MKAnnotation.h"

@implementation PhonyFriendDictionary


static NSArray * dictionaries;
static double distance;


+(NSArray *)returnPhonyFriendDictionary{
    
    if (!dictionaries) {
        // get current position
        distance = 0.1;
    }
        double amplitude = 0.01;
        double omega = 0.01;
        double fixDistance = 0.03;
        double varDistance;
        double incrementDistance = 0.01;
    
        distance+=incrementDistance;
        varDistance = amplitude*sin(omega*distance);
    
          
    
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        NSArray *myCurrentCoordinates;
        if ([[NSUserDefaults standardUserDefaults] arrayForKey:@"current_coordinates"]) {
            
            myCurrentCoordinates =[[NSUserDefaults standardUserDefaults] arrayForKey:@"current_coordinates"];
        }
        else{
            myCurrentCoordinates =@[@37.424, @(-122.165)];
        }
        NSNumber *latitude = [myCurrentCoordinates objectAtIndex:0];
        NSNumber *longitude = [myCurrentCoordinates objectAtIndex:1];
    
    // this is bob
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:@1 forKey:@"eventID"];
        [dict setValue:@1 forKey:@"hungry"];
        [dict setValue:@(latitude.doubleValue-fixDistance   ) forKey:@"latitude"];
        [dict setValue:@(longitude.doubleValue+varDistance     ) forKey:@"longitude"];
        [dict setValue:@"Bob" forKey:@"name"];
        [dict setValue:@"Wants Tacos!!" forKey:@"status"];
        [dict setValue:@1 forKey:@"userID"];
        [dict setValue:[NSDate date] forKey:@"lastUpdated"];
        [dict setValue:@0 forKey:@"added"];
        [dict setValue:@0 forKey:@"blocked"];
    
        [temp addObject:dict];
    
    // this is bill
        dict = [[NSMutableDictionary alloc] init];
        [dict setValue:@1 forKey:@"eventID"];
        [dict setValue:@1 forKey:@"hungry"];
        [dict setValue:@(latitude.doubleValue+fixDistance   ) forKey:@"latitude"];
        [dict setValue:@(longitude.doubleValue-varDistance     ) forKey:@"longitude"];
        [dict setValue:@"Bill" forKey:@"name"];
        [dict setValue:@"Wants Pancakes!!" forKey:@"status"];
        [dict setValue:@2 forKey:@"userID"];
        [dict setValue:[NSDate date] forKey:@"lastUpdated"];
        [dict setValue:@0 forKey:@"added"];
        [dict setValue:@0 forKey:@"blocked"];
    
        [temp addObject:dict];
    
    // this is sue
        dict = [[NSMutableDictionary alloc] init];
        [dict setValue:@1 forKey:@"eventID"];
        [dict setValue:@1 forKey:@"hungry"];
        [dict setValue:@(latitude.doubleValue+varDistance   ) forKey:@"latitude"];
        [dict setValue:@(longitude.doubleValue+fixDistance     ) forKey:@"longitude"];
        [dict setValue:@"Sue" forKey:@"name"];
        [dict setValue:@"Coffee!!" forKey:@"status"];
        [dict setValue:@3 forKey:@"userID"];
        [dict setValue:[NSDate date] forKey:@"lastUpdated"];
        [dict setValue:@0 forKey:@"added"];
        [dict setValue:@0 forKey:@"blocked"];
    
    
        [temp addObject:dict];
    
    // this is rebecca
        dict = [[NSMutableDictionary alloc] init];
        [dict setValue:@1 forKey:@"eventID"];
        [dict setValue:@1 forKey:@"hungry"];
        [dict setValue:@(latitude.doubleValue-varDistance   ) forKey:@"latitude"];
        [dict setValue:@(longitude.doubleValue-fixDistance     ) forKey:@"longitude"];
        [dict setValue:@"Rebecca" forKey:@"name"];
        [dict setValue:@"Wants Pancakes!!" forKey:@"status"];
        [dict setValue:@4 forKey:@"userID"];
        [dict setValue:[NSDate date] forKey:@"lastUpdated"];
        [dict setValue:@0 forKey:@"added"];
        [dict setValue:@0 forKey:@"blocked"];
    
        [temp addObject:dict];
        
        dictionaries = [[NSArray alloc] initWithArray:temp];
        
   // }
    return dictionaries;
}



@end

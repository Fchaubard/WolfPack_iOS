//
//  PhonyFriendDictionary.m
//  WolfPack
//
//  Created by Francois Chaubard on 3/4/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "PhonyFriendDictionary.h"
#import "Friend+MKAnnotation.h"
#import "MyManagedObjectContext.h"

@implementation PhonyFriendDictionary

+(NSArray *)returnPhonyFriendDictionary{
    
   /* if (!dictionaries) {
        // get current position
        distance = 0.1;
    }
        double amplitude = 0.01;
        double omega = 0.01;
        double fixDistance = 0.03;
        double varDistance;
        double incrementDistance = 0.01;
    
        distance+=incrementDistance;
        varDistance = amplitude;
    
          
    
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
    */
    
    
   
   /* NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
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
    
    [temp addObject:dict];*/
    
    
    
    
    
    
    
    
    
    
    
     NSString *sessionid =[MyManagedObjectContext token];
     NSString *str = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/getmywolfpackjson.php?session=%@",sessionid];
     NSURL *URL = [NSURL URLWithString:str];
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
     //request.HTTPMethod = @"POST";
     
     //NSString *params = @"access_token=asdf&action_name=get_apptracker_info";
     
     //NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
     //[request addValue:@"8bit" forHTTPHeaderField:@"Content-Transfer-Encoding"];
     //[request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
     //[request addValue:[NSString stringWithFormat:@"%i", [data length]] forHTTPHeaderField:@"Content-Length"];
     //[request setHTTPBody:data];
     NSError *error = [[NSError alloc] init];
     NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
     
    
    NSArray *jsonArray;
    // if ([NSJSONSerialization isValidJSONObject:responseData]) {
    if ([responseData length]>1){
        jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        for (NSMutableDictionary *dict in jsonArray) {
            NSLog(@"%@", [dict allKeys]);
            NSLog(@"%@", [dict allValues]);
            
        }
        return jsonArray;
    }
    else{
        return nil;
    }
    
}



@end

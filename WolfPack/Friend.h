//
//  Friend.h
//  WolfPack
//
//  Created by Francois Chaubard on 4/25/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friend : NSManagedObject

@property (nonatomic, retain) NSNumber * added;
@property (nonatomic, retain) NSNumber * blocked;
@property (nonatomic, retain) NSNumber * eventID;
@property (nonatomic, retain) NSNumber * hungry;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * userID;

@end

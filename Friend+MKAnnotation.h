//
//  Friend+MKAnnotation.h
//  WolfPack
//
//  Created by Francois Chaubard on 3/1/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "Friend.h"
#import <MapKit/MapKit.h>

@interface Friend (MKAnnotation) <MKAnnotation>

- (UIImage *)thumbnail;  // blocks!
+ (Friend *)friendWithData:(NSDictionary *)friendDictionary inManagedObjectContext:(NSManagedObjectContext *)context;
@end

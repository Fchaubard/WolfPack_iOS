//
//  Friend+MKAnnotation.m
//  WolfPack
//
//  Created by Francois Chaubard on 3/1/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "Friend+MKAnnotation.h"

@implementation Friend (MKAnnotation)
- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    return coordinate;
}

// MapViewController likes annotations to implement this

- (UIImage *)thumbnail
{
    //return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbnailURLString]]];
    return [UIImage imageNamed:@"fficon.png"];
}



+ (Friend *)friendWithData:(NSDictionary *)friendDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    Friend *friend = nil;
    
    // Build a fetch request to see if we can find this Flickr photo in the database.
    // The "unique" attribute in Photo is Flickr's "id" which is guaranteed by Flickr to be unique.
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"userID = %@", [friendDictionary valueForKey:@"userID"]];
    
    // Execute the fetch
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // Check what happened in the fetch
    
    if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
        // handle error
    } else if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
        friend = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:context];
        
        friend.eventID = [friendDictionary valueForKey:@"eventID"];
        friend.hungry = [friendDictionary valueForKey:@"hungry"];
        friend.latitude = [friendDictionary valueForKey:@"latitude"];
        friend.longitude = [friendDictionary valueForKey:@"longitude"];
        friend.name = [friendDictionary valueForKey:@"name"];
        friend.status = [friendDictionary valueForKey:@"status"];
        friend.userID = [friendDictionary valueForKey:@"userID"];
        friend.lastUpdated = [friendDictionary valueForKey:@"lastUpdated"];
        
        friend.added = [friendDictionary valueForKey:@"added"];
        
        friend.blocked = [friendDictionary valueForKey:@"blocked"];
        friend.title = friend.name;
        friend.subtitle = friend.status;
        
        /*NSSet *tagSetStrings = [[NSSet alloc] initWithArray:[[friendDictionary valueForKey:@"tags"] componentsSeparatedByString: @" "]];
        
        NSMutableSet *tagSet = [[NSMutableSet alloc] init];
        for (NSString *string in tagSetStrings) {
            //this is creating a tag
            if (![string isEqualToString:@"cs193pspot"] && ![string isEqualToString:@"portrait"] && ![string isEqualToString:@"landscape"]) {
                Tag *tag = [Tag tagWithName:string inManagedObjectContext:context];
                [tagSet addObject:tag];
            }
        }
         
        
        photo.tagNames = tagSet;
         */
        
    } else { // found the Photo, just return it from the list of matches (which there will only be one of)
        friend = [matches lastObject];
        friend.eventID = [friendDictionary valueForKey:@"eventID"];
        friend.hungry = [friendDictionary valueForKey:@"hungry"];
        friend.latitude = [friendDictionary valueForKey:@"latitude"];
        friend.longitude = [friendDictionary valueForKey:@"longitude"];
        friend.name = [friendDictionary valueForKey:@"name"];
        friend.status = [friendDictionary valueForKey:@"status"];
        friend.userID = [friendDictionary valueForKey:@"userID"];
        friend.lastUpdated = [friendDictionary valueForKey:@"lastUpdated"];
        friend.added = [friendDictionary valueForKey:@"added"];
        friend.blocked = [friendDictionary valueForKey:@"blocked"];
        friend.title = friend.name;
        friend.subtitle = friend.status;
    }
    
    return friend;
}

@end

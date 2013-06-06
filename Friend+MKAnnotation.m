//
//  Friend+MKAnnotation.m
//  WolfPack
//
//  Created by Francois Chaubard on 3/1/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "Friend+MKAnnotation.h"
#import "MyManagedObjectContext.h"
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
    //NSArray *matches = [context executeFetchRequest:request error:&error];
    
    friend = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:context];
        
       // if([friendDictionary valueForKey:@"friendstatus"]==@1){
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterNoStyle];
            friend.eventID = [f numberFromString:[friendDictionary valueForKey:@"chatid"]];
            friend.hungry = [f numberFromString:[friendDictionary valueForKey:@"adjective"]];
            friend.latitude =[f numberFromString:[friendDictionary valueForKey:@"lat"]];
            friend.longitude = [f numberFromString:[friendDictionary valueForKey:@"long"]];
            friend.name = [NSString stringWithFormat:@"%@ %@",[friendDictionary valueForKey:@"fname"],[friendDictionary valueForKey:@"lname"]];
            friend.status = [friendDictionary valueForKey:@"status"];
            friend.userID = [f numberFromString:[friendDictionary valueForKey:@"phone"]];
            //need to change this
            friend.lastUpdated = [friendDictionary valueForKey:@"lastUpdated"];
    
            friend.blocked = [f numberFromString:[friendDictionary valueForKey:@"hidden"]];
            friend.friendStatus = [f numberFromString:[friendDictionary valueForKey:@"friendstatus"]];
    
            if ([friend.eventID isEqualToNumber:@([MyManagedObjectContext eventID])]) { //literals are awesome!!!!!!!!
                friend.added = @1;
            }else{
                friend.added = @0;
            }
    

            friend.title = friend.name;
            friend.subtitle = friend.status;
    
   
       // }
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
      
    return friend;
}

@end

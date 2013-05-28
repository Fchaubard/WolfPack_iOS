//
//  MyManagedObjectContext.m
//  SPoT
//
//  Created by Francois Chaubard on 2/28/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "MyManagedObjectContext.h"
#import <Foundation/Foundation.h>

@implementation MyManagedObjectContext


static UIManagedDocument * document;

// User setting vars
static bool hungry;
static NSString *fname;
static NSString *lname;
static NSString *email;
static NSString *currentAdjective;
static int currentAdjectiveNumber;
static NSString *phoneNumber;
static NSString *status;

/// Chat Vars
static NSMutableArray *friendsInChat;
static NSMutableArray *chats;

+(NSString *)status{
    if (status == nil)
    {
        status = [[NSString alloc] init];
    }
    
    return status;
}

+(NSString *)fname{
    if (fname == nil)
    {
        fname = [[NSString alloc] init];
    }
    
    return fname;
}

+(NSString *)lname{
    if (lname == nil)
    {
        lname = [[NSString alloc] init];
    }
    
    return lname;
}
+(NSString *)email{
    if (email == nil)
    {
        email = [[NSString alloc] init];
    }
    
    return email;
}

+(NSString *)currentAdjective{
    if (currentAdjective == nil)
    {
        currentAdjective = [[NSString alloc] init];
    }
    
    return currentAdjective;
}

+(int)currentAdjectiveNumber{
    
    
    
    return currentAdjectiveNumber;
    
}

+(NSString *)phoneNumber{
    if (phoneNumber == nil)
    {
        phoneNumber = [[NSString alloc] init];
    }
    
    return phoneNumber;
}

+(NSMutableArray *)friendsInChat{
    if (friendsInChat == nil)
    {
        friendsInChat = [[NSMutableArray alloc] init];
    }
    
    return friendsInChat;
}

+(NSMutableArray *)chats{
    
    
    if (chats == nil)
    {
       chats = [[NSMutableArray alloc] init];
    }
    
    return chats;
}

+(void)setStatus:(NSString *)string{
    status = string;
}
+(void)setFname:(NSString *)string{
    fname = string;
}
+(void)setLname:(NSString *)string{
    lname = string;
}
+(void)setEmail:(NSString *)string{
    email=string;
}
+(void)setCurrentAdjective:(NSString *)string{
    currentAdjective = string;
}
+(void)setCurrentAdjectiveNumber:(int)num{
    currentAdjectiveNumber = num;
}
+(void)setPhoneNumber:(NSString *)string{
    phoneNumber = string;
}
+(void)setFriendsInChat:(NSMutableArray *)array{
    friendsInChat = array;
}
+(void)setChats:(NSMutableArray *)array{
    chats = array;
}




+(BOOL)isThisUserHungry{
   
    return hungry;
}
+(void)hungryTrue
{
    hungry = true;
}
+(void)hungryFalse
{
    hungry = false;
}

+(void)returnMyManagedObjectContext:(void(^)(UIManagedDocument *doc, BOOL created))completionBlock{
    
    if (!document) {
        
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Model Document"];
        document = [[UIManagedDocument alloc] initWithFileURL:url];
       
        
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:[document.fileURL path]]) {
        [document saveToURL:document.fileURL
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  completionBlock(document, TRUE);
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                completionBlock(document, TRUE);
            }
        }];
    } else {
        
        completionBlock(document, TRUE);
        
    }
}



@end

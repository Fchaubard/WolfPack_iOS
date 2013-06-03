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
static NSString *token;
static NSString *deviceToken;
static NSString *fname;
static NSString *lname;
static NSString *email;
static NSString *currentAdjective;
static int currentAdjectiveNumber;
static NSString *phoneNumber;
static NSString *status;
static NSMutableArray *newsfeed;
static int chatid;
static int foodicon;
// friends list stuff
static NSMutableArray *pendingFriends;
static NSMutableArray *potentialFriends;
static NSMutableArray *inviteFriends;
/// Chat Vars
static NSMutableArray *friendsInChat;
static NSMutableArray *friendsInChatStatus;

static NSMutableArray *chats;

+(NSString *)token{
    if (token == nil)
    {
        token = [[NSString alloc] init];
    }
    
    return token;
}
+(NSString *)deviceToken{
    if (deviceToken == nil)
    {
        deviceToken = [[NSString alloc] init];
    }
    
    return deviceToken;
}
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
+(NSMutableArray *)friendsInChatStatus{
    if (friendsInChatStatus == nil)
    {
        friendsInChatStatus = [[NSMutableArray alloc] init];
    }
    
    return friendsInChatStatus;
}

+(NSMutableArray *)chats{
    
    
    if (chats == nil)
    {
       chats = [[NSMutableArray alloc] init];
    }
    
    return chats;
}

+(NSMutableArray *)newsfeed{
    
    
    if (newsfeed == nil)
    {
        newsfeed = [[NSMutableArray alloc] init];
    }
    
    return newsfeed;
}

+(int)eventID{
    
    
    
    return chatid;
    
}

+(int)foodicon{
    
    
    
    return foodicon;
    
}
+(NSMutableArray *)pendingFriends{
    
    
    if (pendingFriends == nil)
    {
        pendingFriends = [[NSMutableArray alloc] init];
    }
    
    return pendingFriends;
}
+(NSMutableArray *)potentialFriends{
    
    
    if (potentialFriends == nil)
    {
        potentialFriends = [[NSMutableArray alloc] init];
    }
    
    return potentialFriends;
}
+(NSMutableArray *)inviteFriends{
    
    
    if (inviteFriends == nil)
    {
        inviteFriends = [[NSMutableArray alloc] init];
    }
    
    return inviteFriends;
}




+(void)setToken:(NSString *)string{
    token = string;
}
+(void)setDeviceToken:(NSString *)string{
    deviceToken = string;
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
+(void)setFriendsInChatStatus:(NSMutableArray *)array{
    friendsInChatStatus = array;
}

+(void)setChats:(NSMutableArray *)array{
    chats = array;
}
+(void)setNewsfeed:(NSMutableArray *)array{
    newsfeed = array;
}
+(void)setEventID:(int)num{
    chatid = num;
}
+(void)setFoodIcon:(int)num{
    foodicon = num;
}
+(void)setPendingFriends:(NSMutableArray *)array{
    pendingFriends = array;
}
+(void)setPotentialFriends:(NSMutableArray *)array{
    potentialFriends = array;
}
+(void)setInviteFriends:(NSMutableArray *)array{
    inviteFriends = array;
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

+(NSMutableArray *)possibleAdjectives{
    return [[NSMutableArray alloc] initWithArray:@[@"Hungry",@"Excercising",@"Studying",@"Raging",@"Shopping",@"Coffeeing",@"Bored"]];
    
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


+(void)pullDataWithURL:(NSURL *)url andBlock:(void(^)(NSData* data))completionBlock{
    //get the user data
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *resData, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(), ^ {
             if(resData) {
                 completionBlock(resData);
             }
             
             //[SVProgressHUD dismiss];
         });
     }];
    
}

//to do..

/*
 +(void)pullNewsfeedData{
 }
 +(void)pullWolfpackData{
 }
 +(void)pullAddfriendsData{
 }

*/

+(void)pullChatData{
    
    
    
    
    NSError *e = nil;
    
    NSString *urlText1 = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/getmembersofchatjson.php?session=%@",token];
    
    
    
    // pull the friend status
    [self pullDataWithURL:[NSURL URLWithString:urlText1] andBlock:^(NSData *data){
    
        NSArray *jsonMetaArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: nil];
        
        if (!jsonMetaArray) {
            NSLog(@"Error parsing JSON for CHAT: %@", nil);
        }
        else{
            NSMutableArray *text = [[NSMutableArray alloc] init];
            NSMutableArray *textStatus = [[NSMutableArray alloc] init];
            for(NSDictionary *item in jsonMetaArray) {
                NSLog(@"%@",item);
                NSString *name = [NSString stringWithFormat:@"%@ %@",[item objectForKey:@"fname"],[item objectForKey:@"lname"]];
                [text addObject:name];
                NSString *status = [NSString stringWithFormat:@"%@",[item objectForKey:@"status"]];
                [textStatus addObject:status];
                
                
            }
            friendsInChatStatus = textStatus;
            friendsInChat = text;
            //self->scrollerText = text;
            //self->scrollerStatuses = textStatus;
            
        }
        
       
    
    }];
    
    
    // pull the freinds
    NSString *urlText = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/getchatjson.php?session=%@",token];
    
    [self pullDataWithURL:[NSURL URLWithString:urlText] andBlock:^(NSData *data){
       
    
        chats = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: nil];
        
    }];
   
    
    
    return;
    
}



+(void)pullUserData{
    
    //get the user data
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/getwpuserjson.php?session=%@", [MyManagedObjectContext token]]];
    
    [self pullDataWithURL:url andBlock:^(NSData *data){
        
        NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:nil];
        /*
         [MyManagedObjectContext setFname:[userData valueForKey:@"fname"]];
         [MyManagedObjectContext setLname:[userData valueForKey:@"lname"]];
         [MyManagedObjectContext setEmail:[userData valueForKey:@"email"]];
         [MyManagedObjectContext setPhoneNumber:[userData valueForKey:@"phone"]];
         [MyManagedObjectContext setEventID:[[userData valueForKey:@"chatid"] intValue]];
         [MyManagedObjectContext setFoodIcon:[[userData valueForKey:@"foodicon"] intValue]];
         */
        fname = [userData valueForKey:@"fname"];
        lname = [userData valueForKey:@"lname"];
        email = [userData valueForKey:@"email"];
        phoneNumber = [userData valueForKey:@"phone"];
        chatid = [[userData valueForKey:@"chatid"] intValue];
        foodicon = [[userData valueForKey:@"foodicon"] intValue];
        
        
    }];
    
    return;
    
}


@end

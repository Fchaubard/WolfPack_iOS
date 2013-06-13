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

static UserObject *userObject;

static UIManagedDocument * document;



+(UserObject *)userObject{
    
    if (userObject == nil)
    {
        userObject = [[UserObject alloc] init];
    }
    
    return userObject;
}


+(NSString *)token{
    
    if (userObject.token == nil)
    {
        userObject.token = [[NSString alloc] init];
    }
    
    return userObject.token;
}
+(NSString *)deviceToken{
    if (userObject.deviceToken == nil)
    {
        userObject.deviceToken = [[NSString alloc] init];
    }
    
    return userObject.deviceToken;
}
+(NSString *)status{
    if (userObject.status == nil)
    {
        userObject.status = [[NSString alloc] init];
    }
    
    return userObject.status;
}

+(NSString *)fname{
    if (userObject.fname == nil)
    {
        userObject.fname = [[NSString alloc] init];
    }
    
    return userObject.fname;
}

+(NSString *)lname{
    if (userObject.lname == nil)
    {
        userObject.lname = [[NSString alloc] init];
    }
    
    return userObject.lname;
}
+(NSString *)email{
    if (userObject.email == nil)
    {
        userObject.email = [[NSString alloc] init];
    }
    
    return userObject.email;
}

+(NSString *)currentAdjective{
    if (userObject.currentAdjective == nil)
    {
        userObject.currentAdjective = [[NSString alloc] init];
    }
    
    return userObject.currentAdjective;
}

+(int)currentAdjectiveNumber{
    
    
    
    return userObject.currentAdjectiveNumber;
    
}

+(NSString *)phoneNumber{
    if (userObject.phoneNumber == nil)
    {
        userObject.phoneNumber = [[NSString alloc] init];
    }
    
    return userObject.phoneNumber;
}

+(NSMutableArray *)friendsInChat{
    if (userObject.friendsInChat == nil)
    {
        userObject.friendsInChat = [[NSMutableArray alloc] init];
    }
    
    return userObject.friendsInChat;
}
+(NSMutableArray *)friendsInChatStatus{
    if (userObject.friendsInChatStatus == nil)
    {
        userObject.friendsInChatStatus = [[NSMutableArray alloc] init];
    }
    
    return userObject.friendsInChatStatus;
}

+(NSMutableArray *)chats{
    
    
    if (userObject.chats == nil)
    {
       userObject.chats = [[NSMutableArray alloc] init];
    }
    
    return userObject.chats;
}

+(NSMutableArray *)newsfeed{
    
    
    if (userObject.newsfeed == nil)
    {
        userObject.newsfeed = [[NSMutableArray alloc] init];
    }
    
    return userObject.newsfeed;
}

+(int)eventID{
    
    
    
    return userObject.eventID;
    
}

+(int)foodicon{
    
    
    
    return userObject.foodicon;
    
}
+(NSMutableArray *)pendingFriends{
    
    
    if (userObject.pendingFriends == nil)
    {
        userObject.pendingFriends = [[NSMutableArray alloc] init];
    }
    
    return userObject.pendingFriends;
}
+(NSMutableArray *)potentialFriends{
    
    
    if (userObject.potentialFriends == nil)
    {
        userObject.potentialFriends = [[NSMutableArray alloc] init];
    }
    
    return userObject.potentialFriends;
}
+(NSMutableArray *)inviteFriends{
    
    
    if (userObject.inviteFriends == nil)
    {
        userObject.inviteFriends = [[NSMutableArray alloc] init];
    }
    
    return userObject.inviteFriends;
}



+(void)setUserObject:(UserObject *)userObject1
{
    userObject = userObject1;
}


+(void)setToken:(NSString *)string{
    userObject.token = string;
}
+(void)setDeviceToken:(NSString *)string{
    userObject.deviceToken = string;
}
+(void)setStatus:(NSString *)string{
    userObject.status = string;
}
+(void)setFname:(NSString *)string{
    userObject.fname = string;
}
+(void)setLname:(NSString *)string{
    userObject.lname = string;
}
+(void)setEmail:(NSString *)string{
    userObject.email=string;
}

+(void)setCurrentAdjective:(NSString *)string{
    userObject.currentAdjective = string;
}
+(void)setCurrentAdjectiveNumber:(int)num{
    userObject.currentAdjectiveNumber = num;
}
+(void)setPhoneNumber:(NSString *)string{
    userObject.phoneNumber = string;
}
+(void)setFriendsInChat:(NSMutableArray *)array{
    userObject.friendsInChat = array;
}
+(void)setFriendsInChatStatus:(NSMutableArray *)array{
    userObject.friendsInChatStatus = array;
}

+(void)setChats:(NSMutableArray *)array{
    userObject.chats = array;
}
+(void)setNewsfeed:(NSMutableArray *)array{
    userObject.newsfeed = array;
}
+(void)setEventID:(int)num{
    userObject.eventID = num;
}
+(void)setFoodIcon:(int)num{
    userObject.foodicon = num;
}
+(void)setPendingFriends:(NSMutableArray *)array{
    userObject.pendingFriends = array;
}
+(void)setPotentialFriends:(NSMutableArray *)array{
    userObject.potentialFriends = array;
}
+(void)setInviteFriends:(NSMutableArray *)array{
    userObject.inviteFriends = array;
}


+(BOOL)isThisUserHungry{
   
    return userObject.hungry;
}
+(void)hungryTrue
{
    userObject.hungry = true;
}
+(void)hungryFalse
{
    userObject.hungry = false;
}

+(NSMutableArray *)possibleAdjectives{ // be careful of off by one issue here...
    return [[NSMutableArray alloc]  initWithArray:@[@"Hungry",@"Exercising",@"Studying",@"Raging",@"Shopping",@"Coffeeing",@"Bored"]];
    
}

+(NSMutableArray *)adjectiveImagesChat{
    return [[NSMutableArray alloc] initWithArray:@[@"normal_wolf.png",@"wolfHungryWhiteChat.png",@"wolfExercisingWhiteChat.png",@"wolfStudyingWhiteChat.png",@"wolfRagingWhiteChat.png",@"wolfShoppingWhiteChat.png",@"wolfCoffeeingWhiteChat.png",@"wolfBoredWhiteChat.png",@"normal_wolf.png"]];
}

+(NSMutableArray *)adjectiveImages{
    return [[NSMutableArray alloc] initWithArray:@[@"normal_wolf.png",@"wolfHungry.png",@"wolfExercising.png",@"wolfStudying.png",@"wolfRaging.png",@"wolfShopping.png",@"wolfCoffeeing.png",@"wolfBored.png",@"normal_wolf.png"]];
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
    
    
    
    
    //NSError *e = nil;
    
    NSString *urlText1 = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/getmembersofchatjson.php?session=%@",userObject.token];
    
    
    
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
            userObject.friendsInChatStatus = textStatus;
            userObject.friendsInChat = text;
            //self->scrollerText = text;
            //self->scrollerStatuses = textStatus;
            
        }
        
       
    
    }];
    
    
    // pull the freinds
    NSString *urlText = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/getchatjson.php?session=%@",userObject.token];
    
    [self pullDataWithURL:[NSURL URLWithString:urlText] andBlock:^(NSData *data){
       
    
        userObject.chats = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: nil];
        
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
        userObject.fname = [userData valueForKey:@"fname"];
        userObject.lname = [userData valueForKey:@"lname"];
        userObject.email = [userData valueForKey:@"email"];
        userObject.phoneNumber = [userData valueForKey:@"phone"];
        userObject.eventID = [[userData valueForKey:@"chatid"] intValue];
        userObject.foodicon = [[userData valueForKey:@"foodicon"] intValue];
        
        
    }];
    
    return;
    
}


#pragma mark - helper functions
+(NSArray *)pullWolfData{
    
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
    //NSError *error = [[NSError alloc] init];
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

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



@end

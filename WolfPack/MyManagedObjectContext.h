//
//  MyManagedObjectContext.h
//  SPoT
//
//  Created by Francois Chaubard on 2/28/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyManagedObjectContext : NSObject
// admin stuff
+(NSString *)token;
+(NSString *)deviceToken;
// user stuff
+(NSString *)status;
+(NSString *)fname;
+(NSString *)lname;
+(NSString *)email;
+(NSString *)currentAdjective;
+(int)currentAdjectiveNumber;
+(NSString *)phoneNumber;
+(int)eventID;
+(int)foodicon;
// chat and newsfeed
+(NSMutableArray *)friendsInChat;
+(NSMutableArray *)friendsInChatStatus;
+(NSMutableArray *)chats;
+(NSMutableArray *)newsfeed;
//friends list stuff
+(NSMutableArray *)pendingFriends;
+(NSMutableArray *)potentialFriends;
+(NSMutableArray *)inviteFriends;







+(void)setToken:(NSString *)string;
+(void)setDeviceToken:(NSString *)string;
+(void)setStatus:(NSString *)string;
+(void)setFname:(NSString *)string;
+(void)setLname:(NSString *)string;
+(void)setEmail:(NSString *)string;
+(void)setCurrentAdjective:(NSString *)string;
+(void)setCurrentAdjectiveNumber:(int)num;
+(void)setPhoneNumber:(NSString *)string;
+(void)setFriendsInChat:(NSMutableArray *)array;
+(void)setFriendsInChatStatus:(NSMutableArray *)array;
+(void)setChats:(NSMutableArray *)array;
+(void)setNewsfeed:(NSMutableArray *)array;
+(void)setEventID:(int)num;
+(void)setFoodIcon:(int)num;

+(void)setPendingFriends:(NSMutableArray *)array;
+(void)setPotentialFriends:(NSMutableArray *)array;
+(void)setInviteFriends:(NSMutableArray *)array;

+(NSMutableArray *)possibleAdjectives;

+(BOOL)isThisUserHungry;
+(void)hungryTrue;
+(void)hungryFalse;
+(void)returnMyManagedObjectContext:(void(^)(UIManagedDocument *doc, BOOL created))completionBlock;




+(void)pullUserData;
+(void)pullChatData;



@end

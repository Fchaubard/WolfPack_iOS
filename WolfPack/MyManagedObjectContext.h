//
//  MyManagedObjectContext.h
//  SPoT
//
//  Created by Francois Chaubard on 2/28/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyManagedObjectContext : NSObject

+(NSString *)status;
+(NSString *)fname;
+(NSString *)lname;
+(NSString *)email;
+(NSString *)currentAdjective;
+(int)currentAdjectiveNumber;
+(NSString *)phoneNumber;
+(NSMutableArray *)friendsInChat;
+(NSMutableArray *)chats;

+(void)setStatus:(NSString *)string;
+(void)setFname:(NSString *)string;
+(void)setLname:(NSString *)string;
+(void)setEmail:(NSString *)string;
+(void)setCurrentAdjective:(NSString *)string;
+(void)setCurrentAdjectiveNumber:(int)num;
+(void)setPhoneNumber:(NSString *)string;
+(void)setFriendsInChat:(NSMutableArray *)array;
+(void)setChats:(NSMutableArray *)array;

+(BOOL)isThisUserHungry;
+(void)hungryTrue;
+(void)hungryFalse;
+(void)returnMyManagedObjectContext:(void(^)(UIManagedDocument *doc, BOOL created))completionBlock;

@end

//
//  UserObject.h
//  WolfPack
//
//  Created by Francois Chaubard on 6/5/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObject : NSObject

@property (strong,nonatomic) NSString *token;
@property (strong,nonatomic) NSString *deviceToken;
@property (strong,nonatomic) NSString *status;
@property (strong,nonatomic) NSString *fname;
@property (strong,nonatomic) NSString *lname;
@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) NSString *currentAdjective;
@property (nonatomic) int currentAdjectiveNumber;
@property (strong,nonatomic) NSString *phoneNumber;
@property (nonatomic) int eventID;
@property (nonatomic) int foodicon;
@property (strong,nonatomic) NSMutableArray *friendsInChat;
@property (strong,nonatomic) NSMutableArray *friendsInChatStatus;
@property (strong,nonatomic) NSMutableArray *chats;
@property (strong,nonatomic) NSMutableArray *newsfeed;
@property (strong,nonatomic) NSMutableArray *pendingFriends;
@property (strong,nonatomic) NSMutableArray *potentialFriends;
@property (strong,nonatomic) NSMutableArray *inviteFriends;
@property (nonatomic) bool hungry;


@end

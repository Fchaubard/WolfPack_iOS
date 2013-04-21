//
//  MyManagedObjectContext.h
//  SPoT
//
//  Created by Francois Chaubard on 2/28/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyManagedObjectContext : NSObject

+(BOOL)isThisUserHungry;
+(void)hungryTrue;
+(void)hungryFalse;
+(void)returnMyManagedObjectContext:(void(^)(UIManagedDocument *doc, BOOL created))completionBlock;

@end

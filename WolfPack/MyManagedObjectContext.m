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
static bool hungry;

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

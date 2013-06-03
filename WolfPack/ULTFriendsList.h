//
//  ULTFriendsList.h
//  UserLoginTest
//
//  Created by Rebecca Rich on 3/17/13.
//  Copyright (c) 2013 Rebecca Rich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

@interface ULTFriendsList : UITableViewController <MFMessageComposeViewControllerDelegate> {
    //NSMutableArray *wolfpacklistarray;
}
//@property (strong, nonatomic) IBOutlet NSMutableArray *wolfpacklistarray;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property NSString *originView;
@end

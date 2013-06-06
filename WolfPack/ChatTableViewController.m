//
//  ChatTableViewController.m
//  WolfPack
//
//  Created by Francois Chaubard on 3/15/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "ChatTableViewController.h"
#import "UIBubbleTableView.h"
#import "NSBubbleData.h"
#import "MyManagedObjectContext.h"


@interface ChatTableViewController (){
    IBOutlet UIBubbleTableView *bubbleTable;
    IBOutlet UIView *textInputView;
    IBOutlet UITextField *textField;
    
    NSMutableArray *bubbleData;
}

@end

@implementation ChatTableViewController

-(void)loadChat{
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
        if(bubbleData == NULL){
            bubbleData = [[NSMutableArray alloc] init];
            bubbleTable.bubbleDataSource = self;
        }
        else{
            [bubbleData removeAllObjects];
        }
        
    // getting an NSString
    NSString *token = [MyManagedObjectContext token]; //[prefs stringForKey:@"token"]; //token
    //NSString *token = @"6508477336";
    NSError *e = nil;
    NSString *urlText = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/getchatjson.php?session=%@",token];
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:urlText]];
    NSLog(@"Data: %@",data);
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    
    if (!jsonArray) {
        NSLog(@"Error parsing JSON for CHAT: %@", e);
    }
    else {
        for(NSDictionary *item in jsonArray) {
            NSLog(@"Item: %@", item);
            NSString *fname = [item objectForKey:@"fname"];
            NSString *lname = [item objectForKey:@"lname"];
            NSLog(@"fname: %@",fname);
            NSLog(@"lname: %@",lname);
            NSString *message = [item objectForKey:@"message"];
            NSLog(@"message: %@",message);
            NSString *sessid = [item objectForKey:@"sessid"];
            NSLog(@"sessid: %@",sessid);
            
            if([sessid isEqualToString:token]){ // The current user is the sender
                NSBubbleData *heyBubble = [NSBubbleData dataWithText:message date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
                [bubbleData addObject:heyBubble];
            }
            else{
                NSBubbleData *replyBubble = [NSBubbleData dataWithText:message date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
                replyBubble.avatar = nil;
                [bubbleData addObject:replyBubble];
            }
        }
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    for (UIView* view in self.view.subviews) {
        //[view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    // [bubbleTable setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-40)];
    // [textInputView setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-40, [[UIScreen mainScreen] bounds].size.width, 40) ];
    
    [self loadChat];
    //////
    //NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Hey, you want some taco's?" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
    /////
    //heyBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
    
    /////
    //NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Heck ya!" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    //replyBubble.avatar = nil;
    /////
    
    /////
    //bubbleData = [[NSMutableArray alloc] initWithObjects:heyBubble, replyBubble, nil];
    //bubbleTable.bubbleDataSource = self;
    /////
    
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    bubbleTable.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    bubbleTable.showAvatars = NO;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    bubbleTable.typingBubble = NSBubbleTypingTypeSomebody;
    
    [bubbleTable reloadData];
    
    // Keyboard events
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y -= kbSize.height;
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height -= kbSize.height;
        bubbleTable.frame = frame;
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y += kbSize.height;
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height += kbSize.height;
        bubbleTable.frame = frame;
    }];
}

#pragma mark - Actions

- (IBAction)sayPressed:(id)sender
{
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    NSBubbleData *sayBubble = [NSBubbleData dataWithText:textField.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
    [bubbleData addObject:sayBubble];
    [bubbleTable reloadData];
    
    textField.text = @"";
    [textField resignFirstResponder];
}



@end

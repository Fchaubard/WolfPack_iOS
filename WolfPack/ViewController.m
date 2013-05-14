//
//  ViewController.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

//
// Images used in this example by Petr Kratochvil released into public domain
// http://www.publicdomainpictures.net/view-image.php?image=9806
// http://www.publicdomainpictures.net/view-image.php?image=1358
//

#import "ViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
{
    IBOutlet UIBubbleTableView *bubbleTable;
    IBOutlet UIView *textInputView;
    IBOutlet UITextView *textView;
    IBOutlet HorizontalTextScroller *scroller;
    NSArray *scrollerText;
    NSArray *scrollerStatuses;
    
    NSArray *jsonArray;
    NSMutableArray *bubbleData;
}

@end

@implementation ViewController

-(void)doMainThreadStuff{
    [scroller initWithNames:self->scrollerText
                andStatuses:self->scrollerStatuses
               buttonHeight:30
                    spacing:20
              topOfScroller:4];
    
 

    textView.delegate = self;
    textView.clipsToBounds = YES;
    textView.layer.cornerRadius = 10.0f;
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *token = [prefs stringForKey:@"token"];
    if (!jsonArray) {
        NSLog(@"Error parsing JSON for CHAT:");
    }
    else {
        for(NSDictionary *item in self->jsonArray) {
            
            NSString *senderPhone = [item objectForKey:@"senderphone"];
            NSLog(@"Sender Phone: %@",senderPhone);
            NSString *adminPhone = @"00000000000";
            NSString *message = [item objectForKey:@"message"];
            NSString *messageTime = [item objectForKey:@"timesent"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd*HH:mm:ss"];
            NSDate *myDate = [df dateFromString: messageTime];
            if(![senderPhone isEqualToString:adminPhone]){ //Not Administrative Message:
                NSString *fname = [item objectForKey:@"fname"];
                NSString *lname = [item objectForKey:@"lname"];
                message = [NSString stringWithFormat:@"%@ %@: %@", fname, lname ,message];
                NSLog(@"%@'s Message at: %@ Loaded",fname,myDate);
                if([senderPhone isEqualToString:token]){ // The current user is the sender
                    NSBubbleData *heyBubble = [NSBubbleData dataWithText:message date:myDate type:BubbleTypeMine];
                    [bubbleData addObject:heyBubble];
                }
                else{ //Administrative Message:
                    NSBubbleData *replyBubble = [NSBubbleData dataWithText:message date:myDate type:BubbleTypeSomeoneElse];
                    replyBubble.avatar = nil;
                    [bubbleData addObject:replyBubble];
                }
            }
            else{
                NSLog(@"Admin's Message at: %@ Loaded",myDate);
                //Later create a BubbleTypeAdmin...
                NSBubbleData *adminBubble = [NSBubbleData dataWithText:message date:myDate type:BubbleTypeSomeoneElse];
                //UIImage *avatar = [UIImage alloc];
                //[avatar initWithContentsOfFile:@"wolf1.png"];
                //if(avatar==NULL){ NSLog(@"AVATAR NULL");}
                adminBubble.avatar = nil;
                [bubbleData addObject:adminBubble];
            }
            
            
        }
    }
}


- (BOOL)textView:(UITextView *)thisTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  
    [self adjustTextInputHeightForText:thisTextView.text animated:YES];
    return TRUE;
}

- (void) adjustTextInputHeightForText:(NSString*)text animated:(BOOL)animated {
    
    int h1 = [text sizeWithFont:textView.font].height;
    int h2 = [text sizeWithFont:textView.font constrainedToSize:CGSizeMake(textView.frame.size.width - 16, 170.0f) lineBreakMode:NSLineBreakByWordWrapping].height;
    int inputHeightWithShadow = 44.0f;
    
    [UIView animateWithDuration:(animated ? .1f : 0) animations:^
     {
         int h = h2 == h1 ? inputHeightWithShadow : h2 + 24;
         int delta = h - textInputView.frame.size.height;
         CGRect r2 = CGRectMake(textInputView.frame.origin.x, textInputView.frame.origin.y - delta, textInputView.frame.size.width, h);
         textInputView.frame = r2; //CGRectMake(0, self.frame.origin.y - delta, self.superview.frame.size.width, h);
         textInputView.frame = CGRectMake(textInputView.frame.origin.x, textInputView.frame.origin.y, textInputView.frame.size.width, h);
         
         CGRect r = textView.frame;
         r.origin.y = 12;
         r.size.height = h - 18;
         textView.frame = r;
         
     } completion:^(BOOL finished)
     {
         //
     }];
}

-(void)loadChat{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *token = [prefs stringForKey:@"token"];
    if(bubbleData == NULL){
        bubbleData = [[NSMutableArray alloc] init];
        bubbleTable.bubbleDataSource = self;
    }
    else{
        NSLog(@"Bubble Data Being Cleared!");
        [bubbleData removeAllObjects];
    }
    
    NSError *e = nil;
    
    
    
    NSString *urlText1 = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/getmembersofchatjson.php?session=%@",token];
    NSLog(@"Token: %@",token);
    NSData* data1 = [NSData dataWithContentsOfURL: [NSURL URLWithString:urlText1]];
    NSLog(@"Data: %@",data1);
    NSArray *jsonMetaArray = [NSJSONSerialization JSONObjectWithData: data1 options: NSJSONReadingMutableContainers error: &e];
    
    if (!jsonMetaArray) {
        NSLog(@"Error parsing JSON for CHAT: %@", e);
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
        self->scrollerText = text;
        self->scrollerStatuses = textStatus;
        
    }
    
    NSString *urlText = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/getchatjson.php?session=%@",token];
    NSLog(@"Token: %@",token);
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:urlText]];
    NSLog(@"Data: %@",data);
    self->jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    
   
    
}
    


-(void)refreshPressed{
    NSLog(@"Refresh Pressed!");
    
    
	
    [self loadChat];
    [self doMainThreadStuff];
    
    [bubbleTable reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    [self.view setNeedsDisplay];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshPressed)
                                                 name:@"MessageNotification"
                                               object:nil];
    //UIBarButtonItem *chkmanuaaly = [[UIBarButtonItem alloc]initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshPressed)];
    //self.navigationItem.rightBarButtonItem=chkmanuaaly;
    
    
    // [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    for (UIView* view in self.view.subviews) {
        //[view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    // [bubbleTable setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-40)];
    // [textInputView setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-40, [[UIScreen mainScreen] bounds].size.width, 40) ];
    
    
    
    /////
    //NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"In the mood for tacos? (dont invite Sue..)" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
    
    
    //NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Sure. Never liked her anyway. See you at Coho in 10." date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    //replyBubble.avatar = nil;
    
    //bubbleData = [[NSMutableArray alloc] initWithObjects:heyBubble, replyBubble, nil];
    //bubbleTable.bubbleDataSource = self;
    
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
       
    // Keyboard events
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [SVProgressHUD showWithStatus:@"Doing Stuff"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
    {
    
    [self loadChat];
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
    
    
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self doMainThreadStuff];
            [bubbleTable reloadData];
            [SVProgressHUD dismiss];
        });
    });
    
    
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

-(void)addChatToDB:(NSString *)message{
    
    dispatch_queue_t fetchQ = dispatch_queue_create("Update Status", NULL);
    dispatch_async(fetchQ, ^{
        
        NSLog(@"Chat Added");
        
        //Get current date:
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd*HH:mm:ss"];
        NSString *dateString = [DateFormatter stringFromDate:[NSDate date]];
        NSLog(@"Calculated Current Date: %@",dateString);
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        // getting an NSString
        NSString *token = [prefs stringForKey:@"token"]; //token
        NSString *strippedMessage = [message stringByReplacingOccurrencesOfString:@" " withString:@"!!_____!_____!!"];
        NSString *urlText = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/addchatmessagejson.php?session=%@&message=%@&date=%@",token,strippedMessage,dateString];
        NSLog(@"URLSTRING: %@",urlText);
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:urlText]];
        NSString *serverOutput = [[NSString alloc] initWithData:data
                                                       encoding: NSUTF8StringEncoding];
        NSLog(@"Server Output: %@",serverOutput);
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^ {
     
        });
        
        
        
    });
}

- (IBAction)sayPressed:(id)sender
{
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    [self addChatToDB:textView.text];
    NSBubbleData *sayBubble = [NSBubbleData dataWithText:textView.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
    [bubbleData addObject:sayBubble];
    [bubbleTable reloadData];
    
    textView.text = @"";
    [textView resignFirstResponder];
}

@end

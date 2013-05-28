//
//  ContainerViewController.m
//  WolfPack
//
//  Created by Francois Chaubard on 3/1/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "ContainerViewController.h"
#import "ViewController.h"
#import "MyManagedObjectContext.h"
#import "MyCLLocationManager.h"
#import "SVProgressHUD.h"
#import "SettingsViewController.h"
#import "PopoverTVC.h"
@interface ContainerViewController ()

@property (strong, nonatomic) UITabBarController *containerTBC;
@property (weak, nonatomic) WolfListCDTVC *listViewController;
@property (weak, nonatomic) WolfMapViewController *mapViewController;
@property (weak, nonatomic) SettingsViewController *settingsController;
@property (strong, nonatomic) IBOutlet UIButton *adjectiveButton;
@property (strong, nonatomic) IBOutlet UIButton *chatButton;
@property (strong, nonatomic) IBOutlet HungrySlider *hungrySlider;
@property (strong, nonatomic) IBOutlet UIView *statusInputView;
@property (strong, nonatomic) IBOutlet UITextField *statusTextField;
@property (strong, nonatomic) IBOutlet UIImageView *mainLogo;
@property (strong, nonatomic) IBOutlet UILabel *questionForInput;
@property (strong, nonatomic) UITapGestureRecognizer *tapped;
@property (strong, nonatomic) NSMutableArray *possibleAdjectives;
@property (strong, nonatomic) FPPopoverController *popover;
@property (strong, nonatomic) NSString* currentAdjective;


@property (nonatomic) CGFloat originHeight;

- (IBAction)userChangedHungryStatus:(id)sender;
- (IBAction)userChangedStatus:(id)sender;
- (IBAction)userTappedToChangeStatus:(id)sender; // doing this by code
- (IBAction)adjectiveButtonClicked:(UIButton*)adjectiveButton;

@end

@implementation ContainerViewController



-(void)selectedTableRow:(NSUInteger)rowNum
{
    self.currentAdjective = [self.possibleAdjectives objectAtIndex:rowNum];
    if (![MyManagedObjectContext isThisUserHungry]) {
        
        [self.adjectiveButton setTitle:[NSString stringWithFormat:@"Not %@",self.currentAdjective] forState:UIControlStateNormal];
    }else{
        [self.adjectiveButton setTitle:[NSString stringWithFormat:@"%@",self.currentAdjective] forState:UIControlStateNormal];
    }
   
    
    //update the input question
    if ([self.currentAdjective isEqualToString:[self.possibleAdjectives objectAtIndex:0]]) {
        self.questionForInput.text = @"What are you hungry for?";
        [self.statusTextField setPlaceholder:@"I want Mexican!"];
    }else if ([self.currentAdjective isEqualToString:[self.possibleAdjectives objectAtIndex:1]])
    {
        self.questionForInput.text = @"How you gna excercise?";
        [self.statusTextField setPlaceholder:@"Lets play Soccer!"];
    }else if ([self.currentAdjective isEqualToString:[self.possibleAdjectives objectAtIndex:2]])
    {
        self.questionForInput.text = @"What are you studying?";
        [self.statusTextField setPlaceholder:@"Math sucks!"];
    }else if ([self.currentAdjective isEqualToString:[self.possibleAdjectives objectAtIndex:3]])
    {
        self.questionForInput.text = @"Where you raging bra?";
        [self.statusTextField setPlaceholder:@"TOGA PARTYY!"];
    }else if ([self.currentAdjective isEqualToString:[self.possibleAdjectives objectAtIndex:4]])
    {
        self.questionForInput.text = @"Where are you shopping?";
        [self.statusTextField setPlaceholder:@"Palisades Mall!"];
    }else if ([self.currentAdjective isEqualToString:[self.possibleAdjectives objectAtIndex:5]])
    {
        self.questionForInput.text = @"Where do you want to coffee?";
        [self.statusTextField setPlaceholder:@"Starbucks!"];
    }else if ([self.currentAdjective isEqualToString:[self.possibleAdjectives objectAtIndex:6]])
    {
        self.questionForInput.text = @"What do you wanna do?";
        [self.statusTextField setPlaceholder:@"KITE FLYINGG!"];
    }
    [self.questionForInput sizeToFit];
    [self.adjectiveButton.titleLabel sizeToFit];
    [self.popover dismissPopoverAnimated:YES];
    
    if (self.statusInputView.hidden && [[self hungrySlider] value]==1)
    {
        [self userTappedToChangeStatus:@1];
    }
      
    
    
}

- (IBAction)adjectiveButtonClicked:(UIButton*)adjectiveButton
{
    //the view controller you want to present as popover
    PopoverTVC *controller = [[PopoverTVC alloc] initWithStyle:UITableViewStylePlain];
    controller.delegate = self;
    //[controller setTitle:@"What are you up to?"];
    [controller setAdjectives:self.possibleAdjectives];
    
    //our popover
    self.popover = [[FPPopoverController alloc] initWithViewController:controller];
    self.popover.tint = FPPopoverLightGrayTint;
    if(self.statusTextField.isEditing) //keyboard is showing
    {
        self.popover.contentSize = CGSizeMake(self.popover.contentSize.width, self.popover.contentSize.height/(14/7));
    }else{
        self.popover.contentSize = CGSizeMake(self.popover.contentSize.width, self.popover.contentSize.height);
    }
    
    
    //the popover will be presented from the okButton view
    [self.popover presentPopoverFromView:adjectiveButton];
    
    //no release (ARC enable)
    //[controller release];
}

- (void)viewDidLoad
{    // talk to the server and get user info
    [super viewDidLoad];
    [MyCLLocationManager sharedSingleton];
    
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // saving an NSInteger
    //[prefs setObject:[NSString stringWithFormat:@"6508477336"] forKey:@"token"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(glowChatButton)
                                                 name:@"MessageNotification"
                                               object:nil];
   
    _possibleAdjectives = [[NSMutableArray alloc] initWithArray:@[@"Hungry",@"Excersizing",@"Studying",@"Raging",@"Shopping",@"Coffeeing",@"Bored"]];
}

- (void)viewDidAppear:(BOOL)animated{
    // DISCLAIMER: NOT GOOD DESIGN
    [super viewDidAppear:animated];
    
    if (self.containerTBC) {
        for (UIViewController *v in self.containerTBC.viewControllers)
        {
            if ([v isKindOfClass:[WolfMapViewController class]])
            {
                self.mapViewController = (WolfMapViewController *)v;
            }
            else if([v isKindOfClass:[UINavigationController class]]){
                UINavigationController *navVC = (UINavigationController *)v;
                for (UIViewController *nav_v in navVC.viewControllers) {
                    
                    if ([nav_v isKindOfClass:[WolfListCDTVC class]])
                    {
                        self.listViewController = (WolfListCDTVC *)nav_v;
                    }
                    else if ([nav_v isKindOfClass:[SettingsViewController class]])
                    {
                        self.settingsController = (SettingsViewController *)nav_v;
                    }
                    
                }
            }
        }
    }
    
    if (![MyManagedObjectContext isThisUserHungry]) {
        
        [self.hungrySlider setValue:0.0];
        [self.adjectiveButton setTitle:[NSString stringWithFormat:@"Not %@",self.currentAdjective] forState:UIControlStateNormal];
        [self.chatButton setEnabled:false];
        
        [self.chatButton setAlpha:0.5];
        [self.hungrySlider addTarget:self action:@selector(userChangedHungryStatus:) forControlEvents:UIControlEventValueChanged];
        [self.statusInputView setHidden:true];
        [self.mapViewController.mapView setHidden:true];
        [self.mapViewController.refreshButton setHidden:true];
        //[self hideTabBar:self.containerTBC];
        [self.containerTBC setSelectedIndex:2];
        
    }else{
        
        [self.hungrySlider setValue:1.0];
        [self.adjectiveButton setTitle:self.currentAdjective forState:UIControlStateNormal];
        //[self.chatButton setEnabled:true];
        //[self.chatButton setAlpha:1.0];
        [self.hungrySlider addTarget:self action:@selector(userChangedHungryStatus:) forControlEvents:UIControlEventValueChanged];
        
        [self.statusInputView setHidden:true];
        //[self showTabBar:self.containerTBC];
        
        
    }
}

-(void)glowChatButton{
    
    [UIView animateWithDuration:0.7f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        [UIView setAnimationRepeatCount:3];
        
        //self.chatButton.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        
        
        [self.chatButton setBackgroundColor:[UIColor blueColor]];
        
        
    } completion:^(BOOL finished) {
          [UIView animateWithDuration:0.7f delay:0 options: UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction  animations:^{
                    [self.chatButton setBackgroundColor:[UIColor clearColor]];
                    self.chatButton.layer.shadowRadius = 0.0f;
                    self.chatButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
               } completion:^(BOOL finished) {
                   
             }];      
    }];
    
    
}

-(void)slideInStatus{
    [self.statusInputView setHidden:false];
    
    self.statusInputView.frame = CGRectMake(self.statusInputView.frame.origin.x, self.statusInputView.frame.origin.y-50, self.statusInputView.frame.size.width, self.statusInputView.frame.size.height);
    
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.statusInputView.frame = CGRectMake(self.statusInputView.frame.origin.x, self.statusInputView.frame.origin.y+50, self.statusInputView.frame.size.width, self.statusInputView.frame.size.height);
    } completion:^(BOOL finished) {
        [self.statusTextField selectAll:self];
        
        //[UIMenuController sharedMenuController].menuVisible = NO;
    }
     ];
    
}

-(void)slideOutStatus{
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.statusInputView.frame = CGRectMake(self.statusInputView.frame.origin.x, self.statusInputView.frame.origin.y-50, self.statusInputView.frame.size.width, self.statusInputView.frame.size.height);
        
    } completion:^(BOOL finished) {
        self.statusInputView.frame = CGRectMake(self.statusInputView.frame.origin.x, self.statusInputView.frame.origin.y+50, self.statusInputView.frame.size.width, self.statusInputView.frame.size.height);
        [self.statusInputView setHidden:true];
        [self.statusTextField resignFirstResponder];
    }
     ];
    
}

- (IBAction)userChangedStatus:(id)sender{
    
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"Joining the %@...",self.currentAdjective]];
    [self slideOutStatus];
    [self.chatButton setEnabled:TRUE];
    [self.chatButton setAlpha:1.0];
    [self.view setNeedsDisplay];
    [self.mapViewController.mapView setHidden:false];
    [self.mapViewController.refreshButton setHidden:false];
    self.mapViewController.mapView.alpha = 0.0;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.mapViewController.mapView.alpha = 1.0;
    }];
    
    [self updateStatusWithStatus:[self.statusTextField text] andAdjective:@1];
    [self.view endEditing:YES];
    
    
}

- (IBAction)userTappedToChangeStatus:(id)sender{
    
    if (self.statusInputView.hidden) {
        [self slideInStatus];
    }else{
        [self slideOutStatus];
    }
}

-(void)updateStatusWithStatus:(NSString *)status
                 andAdjective:(NSNumber *)adjective{
    dispatch_queue_t fetchQ = dispatch_queue_create("Update Status", NULL);
    dispatch_async(fetchQ, ^{
        
        CLLocation *loc = [MyCLLocationManager sharedSingleton].locationManager.location;
        
        NSString *sessionid =[[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
        NSString *strippedStatus = [status stringByReplacingOccurrencesOfString:@" " withString:@"!!_____!_____!!"];
        NSString *str = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/updatemystatusjson.php?session=%@&adjective=%d&lat=%f&long=%f&status=%@",sessionid,[adjective intValue],loc.coordinate.latitude,loc.coordinate.longitude,strippedStatus];
        NSURL *URL = [NSURL URLWithString:str];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        //NSError *error = [[NSError alloc] init];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSString * string = [[NSString alloc] initWithData:responseData encoding:
                             NSASCIIStringEncoding];
        
        
        
        if (string.intValue == 1) {
            NSLog(@"asdfa");
        } else {
            NSLog(@"asdfa");
        }
        sleep(2.8);
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            [SVProgressHUD dismiss];
            [self.mapViewController updateRegion];
        });
        
        
        
    });
    return;
    
}

- (IBAction)userChangedHungryStatus:(id)sender{
    
    //  if (self.hungrySlider.valueChanged) {
    //make sure we have the most current VC's
    
    if (self.hungrySlider.value > 0.5 && ![self.adjectiveButton.titleLabel.text isEqual:self.currentAdjective]) {
        // user is hungry
        // fade out the not hungry status
        [MyManagedObjectContext hungryTrue];
        [self fadeOutLabel];
        [self slideInStatus];
        [self updateStatusWithStatus:self.currentAdjective andAdjective:@1];
        [self.adjectiveButton setTitle:self.currentAdjective forState:UIControlStateNormal];
        //[self.chatButton setEnabled:TRUE];
        //[self.chatButton setAlpha:1.0];
        
        
        [self.containerTBC setSelectedIndex:0];
        [self.adjectiveButton setNeedsDisplay];
        [self fadeInLabel];
        
        //[self showTabBar:self.containerTBC];
        [self.settingsController switchViews:1]; // switch to settings view
        
        
    }else if (self.hungrySlider.value <= 0.5 && [self.adjectiveButton.titleLabel.text isEqual:self.currentAdjective]){
        // user is not hungry
        
        [MyManagedObjectContext hungryFalse];
        [self fadeOutLabel];
        [self slideOutStatus];
        [self updateStatusWithStatus:@"" andAdjective:@0];
        [self.adjectiveButton setTitle:[NSString stringWithFormat:@"Not %@",self.currentAdjective] forState:UIControlStateNormal];
        [self.chatButton setEnabled:FALSE];
        [self.chatButton setAlpha:0.5];
        [self.containerTBC setSelectedIndex:2];
        [self.adjectiveButton setNeedsDisplay];
        [self fadeInLabel];
        [self.settingsController switchViews:0]; // send them home
        self.mapViewController.mapView.alpha = 1.0;
        [UIView animateWithDuration:1.0 animations:^{
            self.mapViewController.mapView.alpha = 0.0;
        }];
        //[self.mapViewController.mapView setHidden:true];
        //[self.mapViewController.refreshButton setHidden:true];
        //[self hideTabBar:self.containerTBC];
    }
    
    // }
    
    
}
// Method implementations
- (void)hideTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            self.originHeight = view.frame.origin.y;
            
            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
    }
    
    [UIView commitAnimations];
}

- (void)showTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    if(self.originHeight ==0){
        self.originHeight = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"originHeight"] intValue];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.originHeight] forKey:@"originHeight"];
    }
    
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, self.originHeight, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, self.originHeight)];
        }
    }
    
    [UIView commitAnimations];
}
-(void) fadeInLabel
{
    [UIView animateWithDuration:1.0 animations:^{
        self.adjectiveButton.alpha = 1.0;
        
    }];
    
}

-(void) fadeOutLabel
{
    [UIView animateWithDuration:1.0 animations:^{
        self.adjectiveButton.alpha = 0.0;
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EmbeddedSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[UITabBarController class]]) {
            self.containerTBC = segue.destinationViewController;
        }
    }
    if ([segue.identifier isEqualToString:@"Chat"]) {
        [SVProgressHUD dismiss];
        
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return false;//(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"token"]) {
        if ([[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"]!=@"no")
        {
            NSLog(@"logged In alreadyyy");
        }else{
            NSLog(@"no device token");
        }
    }else{
        NSLog(@"not alraedy logged in");
          [self performSegueWithIdentifier: @"noToken" sender: self];
    }
    
    
    self.tapped=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTappedToChangeStatus:)];
    
    [self.tapped setNumberOfTouchesRequired:1];
    self.tapped.delegate = self;
    [self.mainLogo addGestureRecognizer:self.tapped];
    self.currentAdjective = [self.possibleAdjectives objectAtIndex:0];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

@end

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
@interface ContainerViewController ()

@property (strong, nonatomic) UITabBarController *containerTBC;
@property (weak, nonatomic) WolfListCDTVC *listViewController;
@property (weak, nonatomic) WolfMapViewController *mapViewController;
@property (weak, nonatomic) SettingsViewController *settingsController;
@property (strong, nonatomic) IBOutlet UILabel *hungryLabel;
@property (strong, nonatomic) IBOutlet UIButton *chatButton;
@property (strong, nonatomic) IBOutlet HungrySlider *hungrySlider;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapped;
@property (strong, nonatomic) IBOutlet UIView *statusInputView;
@property (strong, nonatomic) IBOutlet UITextField *statusTextField;



@property (nonatomic) CGFloat originHeight;

- (IBAction)userChangedHungryStatus:(id)sender;
- (IBAction)userChangedStatus:(id)sender;
- (IBAction)userTappedToChangeStatus:(id)sender;

@end

@implementation ContainerViewController



- (void)viewDidLoad
{    // talk to the server and get user info
    [super viewDidLoad];
    [MyCLLocationManager sharedSingleton];
    
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // saving an NSInteger
    //[prefs setObject:[NSString stringWithFormat:@"6508477336"] forKey:@"token"];
    
    self.tapped.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated{
    // DISCLAIMER: NOT GOOD DESIGN
    [super viewDidLoad];
   
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
        [self.hungryLabel setText:@"Not Hungry"];
        [self.chatButton setEnabled:false];
        [self.chatButton setAlpha:0.5];
        [self.hungrySlider addTarget:self action:@selector(userChangedHungryStatus:) forControlEvents:UIControlEventValueChanged];
        [self.statusInputView setHidden:true];
        [self.mapViewController.mapView setHidden:true];
        [self.mapViewController.refreshButton setHidden:true];
        [self hideTabBar:self.containerTBC];
        [self.containerTBC setSelectedIndex:2];
        
    }else{
        
        [self.hungrySlider setValue:1.0];
        [self.hungryLabel setText:@"Hungry"];
        //[self.chatButton setEnabled:true];
        //[self.chatButton setAlpha:1.0];
        [self.hungrySlider addTarget:self action:@selector(userChangedHungryStatus:) forControlEvents:UIControlEventValueChanged];
        
        [self.statusInputView setHidden:true];
        [self showTabBar:self.containerTBC];
        
        
    }
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
   
    [SVProgressHUD showWithStatus:@"Joining the hungry..."];
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
       
        if (self.hungrySlider.value > 0.5 && ![self.hungryLabel.text isEqual:@"Hungry"]) {
            // user is hungry
            // fade out the not hungry status
            [MyManagedObjectContext hungryTrue];
            [self fadeOutLabel];
            [self slideInStatus];
            [self updateStatusWithStatus:@"Hungry!" andAdjective:@1];
            [self.hungryLabel setText:@"Hungry"];
            //[self.chatButton setEnabled:TRUE];
            //[self.chatButton setAlpha:1.0];
            
            
            [self.containerTBC setSelectedIndex:0];
            [self.hungryLabel setNeedsDisplay];
            [self fadeInLabel];
            
            [self showTabBar:self.containerTBC];
            [self.settingsController switchViews:1]; // switch to settings view
            
            
        }else if (self.hungrySlider.value <= 0.5 && [self.hungryLabel.text isEqual:@"Hungry"]){
            // user is not hungry
            
            [MyManagedObjectContext hungryFalse];
            [self fadeOutLabel];
            [self slideOutStatus];
            [self updateStatusWithStatus:@"" andAdjective:@0];
            [self.hungryLabel setText:@"Not Hungry"];
            [self.chatButton setEnabled:FALSE];
            [self.chatButton setAlpha:0.5];
            [self.containerTBC setSelectedIndex:2];
            [self.hungryLabel setNeedsDisplay];
            [self fadeInLabel];
            [self.settingsController switchViews:0]; // send them home
            self.mapViewController.mapView.alpha = 1.0;
            [UIView animateWithDuration:1.0 animations:^{
                self.mapViewController.mapView.alpha = 0.0;
            }];
            //[self.mapViewController.mapView setHidden:true];
            //[self.mapViewController.refreshButton setHidden:true];
            [self hideTabBar:self.containerTBC];
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
        self.hungryLabel.alpha = 1.0;
        
    }];
    
}

-(void) fadeOutLabel
{
    [UIView animateWithDuration:1.0 animations:^{
        self.hungryLabel.alpha = 0.0;
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
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

@end

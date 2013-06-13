//
//  ContainerViewController.h
//  WolfPack
//
//  Created by Francois Chaubard on 3/1/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HungrySlider.h"
#import "WolfMapViewController.h"
#import "WolfListCDTVC.h"
#import "FPPopoverController.h"
#import "ARCMacros.h"
#import "ULTDataViewController.h"

@interface ContainerViewController : UIViewController <UIGestureRecognizerDelegate, FPPopoverControllerDelegate>

-(void)selectedTableRow:(NSUInteger)rowNum;


@end

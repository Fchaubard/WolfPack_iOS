//
//  ULTModelController.h
//  UserLoginTest
//
//  Created by Rebecca Rich on 3/4/13.
//  Copyright (c) 2013 Rebecca Rich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ULTDataViewController;

@interface ULTModelController : NSObject <UIPageViewControllerDataSource>

- (ULTDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(ULTDataViewController *)viewController;

@end

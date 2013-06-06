//
//  Created by Matt Greenfield on 24/05/12
//  Copyright (c) 2012 Big Paua. All rights reserved
//  http://bigpaua.com/
//

#import <UIKit/UIKit.h>
#import "MGScrollView.h"

@class MGBox;

@interface NewsfeedViewController : UIViewController <UIScrollViewDelegate>

@property (strong,nonatomic) MGScrollView *scroller;
- (void)addBox:(UIButton *)sender;
- (void)removeBox:(UIButton *)sender;
- (void)moveUp:(UIButton *)sender;
- (void)moveDown:(UIButton *)sender;
- (void)shuffle;

- (MGBox *)parentBoxOf:(UIView *)view;
- (UIButton *)button:(NSString *)title for:(SEL)selector;

@end

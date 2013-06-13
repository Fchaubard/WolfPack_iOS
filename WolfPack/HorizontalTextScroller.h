//
//  HorizontalTextScroller.h
//  iPhone Practice 1
//
//  Created by Francois Chaubard on 4/30/13.
//
//

#import <UIKit/UIKit.h>

@interface HorizontalTextScroller : UIScrollView <UIGestureRecognizerDelegate>

@property (strong,nonatomic) NSArray *text;
@property (strong,nonatomic) NSArray *statuses;
@property (nonatomic) int buttonHeight;
@property (nonatomic) int spacing;
@property (nonatomic) int distanceFromTopOfScroller;
@property (nonatomic) BOOL bigViewBoolean;



-(void)initWithNames:(NSArray *)array
         andStatuses:(NSArray *)status_array
        buttonHeight:(int)buttonheight
             spacing:(int)spacing
       topOfScroller:(int)topheight;

-(void)refreshScroller:(NSMutableArray *)array;

@end

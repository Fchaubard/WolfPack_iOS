//
//  HorizontalTextScroller.h
//  iPhone Practice 1
//
//  Created by Francois Chaubard on 4/30/13.
//
//

#import <UIKit/UIKit.h>

@interface HorizontalTextScroller : UIScrollView

@property (strong,nonatomic) NSMutableArray *text;
@property (nonatomic) int buttonHeight;
@property (nonatomic) int spacing;
@property (nonatomic) int distanceFromTopOfScroller;


-(void)initWithArray:(NSMutableArray *)array buttonHeight:(int)buttonheight spacing:(int)spacing topOfScroller:(int)topheight;

-(void)refreshScroller:(NSMutableArray *)array;

@end

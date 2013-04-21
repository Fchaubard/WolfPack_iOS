//
//  HungrySlider.m
//  WolfPack
//
//  Created by Francois Chaubard on 3/1/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "HungrySlider.h"
@interface HungrySlider ()

@property (assign, nonatomic, readwrite) float oldPosition;


@end

@implementation HungrySlider


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


#pragma mark -
#pragma mark Touch tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL beginTracking = [super beginTrackingWithTouch:touch withEvent:event];
    self.valueChanged = FALSE;
    if (beginTracking)
    {   
        self.oldPosition = self.value;
    }
    return beginTracking;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
   
        if (self.value > 0.5) {
            
            [self setValue:1.0 animated:TRUE];
            if (self.oldPosition <0.5) {
                self.valueChanged = true;
            }else{
                 self.valueChanged = false;
            }
            
        }else{
            [self setValue:0.0 animated:TRUE];
            if (self.oldPosition >=0.5) {
                self.valueChanged = true;
            }else{
                self.valueChanged = false;
            }
        }
        
        
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

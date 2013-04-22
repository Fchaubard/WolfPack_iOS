//
//  WolfAnnotationView.m
//  WolfPack
//
//  Created by Francois Chaubard on 3/10/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "WolfAnnotationView.h"

@implementation WolfAnnotationView

CGPoint startPoint;
CAShapeLayer *circle;
CAShapeLayer *touchPoint1;
CAShapeLayer *touchPoint2;
double height;
double deltaInWidth;
double defaultTouchSize;
bool animating;
double thumbSize;
CABasicAnimation *scaleAnim;

typedef enum {
    NotTouching = 0,
    MessingAround = 1,
    AddingAFriend = 2,
    HidingFromAFriend = 3
} UserTouchState;


UserTouchState touchState;

- (id)initWithFrame:(CGRect)frame andAnnotation:(id<MKAnnotation>)thisAnnotation withReuseId:(NSString *)string
{
    self = [super initWithAnnotation:thisAnnotation reuseIdentifier:string];
    if (self) {
        [self setFrame:frame];
        self.annotation = (Friend *)thisAnnotation;
        // Initialization code
        _recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleGesture)];
        defaultTouchSize = 0.5;
        
        _smallView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"normal_wolf.png"]];
        _bigView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wolf4.png"]];
        [_recognizer setDelegate:self];
        [_smallView addGestureRecognizer:_recognizer];
        [_bigView addGestureRecognizer:_recognizer];
        
        self.name = [[UILabel alloc] init];
        self.name.text = [self.annotation title];
        self.name.textAlignment=NSTextAlignmentCenter;
        
        self.status = [[UILabel alloc] init];
        self.status.text = [self.annotation subtitle];
        self.status.textAlignment=NSTextAlignmentCenter;
        
        [self addSubview:_smallView];
        [self addSubview:_bigView];
        
     
        
        [self addGestureRecognizer:_recognizer];
        thumbSize = 10;
        touchState = NotTouching;
        animating = false;
        [self showSmallView];
        
        
    }
    return self;
}
- (IBAction)handleGesture{
    //NSLog(@"asdfasdfa");
}


-(void)showBigView{
    
        [self.smallView setHidden:true];
        [self.bigView setHidden:false];
        [circle removeFromSuperlayer];
        [touchPoint1 removeFromSuperlayer];
        [touchPoint2 removeFromSuperlayer];
    
    
        circle = nil;
    
        circle =[self createRadialView:self.radius];
        [self.layer addSublayer:circle];
        [self setNeedsDisplay];
    
}

-(void)showSmallView{
    [self.smallView setHidden:false];
    [self.bigView setHidden:true];
    [circle removeFromSuperlayer];
    [touchPoint1 removeFromSuperlayer];
    [touchPoint2 removeFromSuperlayer];
    circle = nil;
    if ([(Friend *)self.annotation blocked]==@1) {
        [self.smallView setAlpha:0.5];
        [self.smallView performSelectorOnMainThread:@selector(setImage:) withObject: [UIImage imageNamed:@"hidden_wolf.png"] waitUntilDone:YES];
    }else{
        if ([(Friend *)self.annotation added]==@1) {
            [self.smallView setFrame:CGRectMake(self.smallView.frame.origin.x, self.smallView.frame.origin.y, 50, 50)];
            [self.smallView performSelectorOnMainThread:@selector(setImage:) withObject: [UIImage imageNamed:@"friend_wolf.png"] waitUntilDone:YES];
            
        }else{
            [self.smallView setAlpha:1.0];
            [self.smallView setFrame:CGRectMake(self.smallView.frame.origin.x, self.smallView.frame.origin.y, 30, 30)];
            [self.smallView performSelectorOnMainThread:@selector(setImage:) withObject: [UIImage imageNamed:@"normal_wolf.png"] waitUntilDone:YES];
        }
    }
 
    
    self.status.hidden =true;
    self.name.hidden =false;
    self.name.text = [self.annotation title];
    // place the name
    float width = 40;
   // self.name.text = @"John W.";
    [self.name setFrame:CGRectMake(self.bounds.size.width/2 - 3*width/2,40, 3*width, 20)];
    [self.name setClipsToBounds:FALSE];
    self.name.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    self.name.opaque = FALSE;
    [self addSubview:self.name];
    
    [self setNeedsDisplay];
}


// Touch began on view so save the start point
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    touchState = MessingAround;
    
   
    
    [self showBigView];
    
    if ([touches count] != 1) {
      // handle this better
        return;
    }
    else
    {
        startPoint = [[touches anyObject] locationInView:self];
         
    }
}

// Track the move of the current gesture
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    NSLog(@"%f %f", [[touches anyObject] locationInView:self].x, [[touches anyObject] locationInView:self].y );
    //if (self.state == UIGestureRecognizerStateFailed)
    //    return;
    [touchPoint1 removeFromSuperlayer];
    [touchPoint2 removeFromSuperlayer];
    if (!animating) {
        
    
        // Get the current and previous touch locations
        CGPoint newPoint    = [[touches anyObject] locationInView:self];
        //CGPoint prevPoint   = [[touches anyObject] previousLocationInView:self];
      
       
        
        
        
        double rad1 = [self calcRadius:newPoint.x-deltaInWidth andDeltY:newPoint.y - height];
        
        touchPoint1 =  [self creatTouchPointAt:deltaInWidth andHeight:height andRadius:30*[self sigmoidAtValue:rad1]];
        
        double rad2 = [self calcRadius:newPoint.x-(self.bounds.size.width-deltaInWidth) andDeltY:newPoint.y - height];
        
          touchPoint2 =  [self creatTouchPointAt:(self.bounds.size.width-deltaInWidth) andHeight:height andRadius:30*[self sigmoidAtValue:rad2]];
       
        if (rad1>thumbSize && rad2>thumbSize) {
            touchState = MessingAround;
        }else if(rad1<thumbSize){
            if (touchState!=AddingAFriend) {
                [touchPoint1 removeFromSuperlayer];
                NSLog(@"add %@", [self.annotation title]);
                if ([(Friend *)self.annotation added]==@0) {
                    [self hotSpotFunctionalityTo:touchPoint1 WithText:@"Add Friend?"];
                    
                }else{
                    [self hotSpotFunctionalityTo:touchPoint1 WithText:@"Remove Friend?"];
                    
                }
                touchState = AddingAFriend;
            }
            touchPoint1.strokeColor = [[UIColor whiteColor] CGColor];
            touchPoint1.fillColor   = [[UIColor whiteColor] CGColor];
        }else if(rad2<thumbSize){
            if (touchState != HidingFromAFriend) {
                [touchPoint2 removeFromSuperlayer];
                if ([(Friend *)self.annotation blocked]==@0) {
                    [self hotSpotFunctionalityTo:touchPoint2 WithText:@"Hide From Friend?"];
                    
                }else{
                    [self hotSpotFunctionalityTo:touchPoint2 WithText:@"Unhide From Friend?"];
                    
                }
               
                touchState = HidingFromAFriend;
            }
            touchPoint2.strokeColor = [[UIColor whiteColor] CGColor];
            touchPoint2.fillColor   = [[UIColor whiteColor] CGColor];
        }else{
            NSLog(@"rad1 and rad2 issue");
        }
        
      
        
      
        
        if (touchState == MessingAround) {
            self.status.text = [self.annotation subtitle];
        }
        [touchPoint1 removeFromSuperlayer];
        [touchPoint2 removeFromSuperlayer];
        [self.layer addSublayer:touchPoint1];
        [touchPoint1 setNeedsDisplay];
        [self.layer addSublayer:touchPoint2];
        [touchPoint2 setNeedsDisplay];
            
    }
}

-(void) fadeInLabel
{
    [UIView animateWithDuration:0.3 animations:^{
        self.status.alpha = 1.0;
        
    }];
    
}

-(void) fadeOutLabel
{
    [UIView animateWithDuration:0.3 animations:^{
        self.status.alpha = 0.0;
    }];
}
-(void)hotSpotFunctionalityTo:(CAShapeLayer *)shape WithText:(NSString*)text{
    shape.strokeColor = [[UIColor whiteColor] CGColor];
    shape.fillColor   = [[UIColor whiteColor] CGColor];
    if (self.status.text!=text) {
        [self fadeOutLabel];
        self.status.text = text;
        [self fadeInLabel];
    }
    
    
}
-(double)calcRadius:(double)deltX andDeltY:(double)deltY{
    
    double radius = sqrt((deltX*deltX) + (deltY*deltY));
    return radius = radius<thumbSize? 0:radius; // floor the value so the size doesnt go bigger
   
    
}

-(double)sigmoidAtValue:(double)radius{
    
    return (2/(1 + exp(abs(radius)/10)) + defaultTouchSize); // 10 is to smooth the function 0.5 to floor it
    
}

// The gesture will fail if touche was cancelled
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"cancelled");
    
    double rad1 = [self calcRadius:[[touches anyObject] locationInView:self].x-deltaInWidth andDeltY:[[touches anyObject] locationInView:self].y - height];
    if (rad1<thumbSize) {
        if ([(Friend *)self.annotation added]==@0) {
            NSLog(@"add %@", [self.annotation title]);
            [(Friend *)self.annotation setAdded:@1];
        }else{
            NSLog(@"unadd %@", [self.annotation title]);
            [(Friend *)self.annotation setAdded:@0];
        }
    }

    
    
    
    double rad2 = [self calcRadius:[[touches anyObject] locationInView:self].x-(self.bounds.size.width-deltaInWidth) andDeltY:[[touches anyObject] locationInView:self].y - height];
    
    if (rad2<thumbSize) {
        if ([(Friend *)self.annotation blocked]==@0) {
            NSLog(@"block %@", [self.annotation title]);
            [(Friend *)self.annotation setBlocked:@1];
        }else{
            NSLog(@"unblock %@", [self.annotation title]);
            [(Friend *)self.annotation setBlocked:@0];
        }
    }
    
    
    touchState = NotTouching;
    [self showSmallView];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // check for all the spots we want to look at!
    animating = false;
    NSLog(@"ended");
    
    
    double rad1 = [self calcRadius:[[touches anyObject] locationInView:self].x-deltaInWidth andDeltY:[[touches anyObject] locationInView:self].y - height];
    if (rad1<thumbSize) {
        if ([(Friend *)self.annotation added]==@0) {
            NSLog(@"add %@", [self.annotation title]);
            [(Friend *)self.annotation setAdded:@1];
        }else{
            NSLog(@"unadd %@", [self.annotation title]);
            [(Friend *)self.annotation setAdded:@0];
        }
    }
    
    
    
    double rad2 = [self calcRadius:[[touches anyObject] locationInView:self].x-(self.bounds.size.width-deltaInWidth) andDeltY:[[touches anyObject] locationInView:self].y - height];
    
    if (rad2<thumbSize) {
        if ([(Friend *)self.annotation blocked]==@0) {
            NSLog(@"block %@", [self.annotation title]);
            [(Friend *)self.annotation setBlocked:@1];
        }else{
            NSLog(@"unblock %@", [self.annotation title]);
            [(Friend *)self.annotation setBlocked:@0];
        }
    }
    
    
    
    touchState = NotTouching;
    [self showSmallView];
    
}


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

-(UIBezierPath *)createRadialBezPath:(double)radius{
    
    double angle = DEGREES_TO_RADIANS(45);
    UIBezierPath* circlePath =[UIBezierPath bezierPath];
    [circlePath moveToPoint:CGPointMake( self.bounds.size.width/2, self.bounds.size.height/2)];
    
    [circlePath addLineToPoint:CGPointMake(self.bounds.size.width/2-radius*cos(angle),self.bounds.size.height/2-radius*sin(angle))];
    
    /*[circlePath addCurveToPoint:CGPointMake(self.bounds.origin.x+2*cos(DEGREES_TO_RADIANS(45))*radius,self.bounds.origin.y-radius)
     controlPoint1:CGPointMake( self.bounds.size.width/2-5, self.bounds.size.height/2 - 2*radius)
     controlPoint2:CGPointMake(self.bounds.size.width/2+5, self.bounds.size.height/2 - 2*radius)];*/
    [circlePath addArcWithCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:radius startAngle:DEGREES_TO_RADIANS(270)-angle endAngle:DEGREES_TO_RADIANS(270)+angle clockwise:YES];
    
    [circlePath addLineToPoint:CGPointMake( self.bounds.size.width/2, self.bounds.size.height/2)];
    [circlePath addLineToPoint:CGPointMake( self.bounds.size.width/2, self.bounds.size.height/2-self.radius)];
    
    return circlePath;
}

-(CAShapeLayer *)creatTouchPointAt:(double)x andHeight:(double)y andRadius:(double)rad{
    UIBezierPath* circlePath =[UIBezierPath bezierPathWithArcCenter:CGPointMake(x, y) radius:rad startAngle:DEGREES_TO_RADIANS(0.1) endAngle:DEGREES_TO_RADIANS(0) clockwise:YES];
    
    CAShapeLayer *spot = [CAShapeLayer layer];
    spot.path = circlePath.CGPath;
    spot.strokeColor = [[UIColor blackColor] CGColor];
    spot.fillColor   = [[UIColor colorWithRed:0 green:255 blue:128 alpha:0.9] CGColor];
    spot.lineWidth   = 1.0;
    spot.strokeEnd   = 1.0;
    
    /*CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
     anim.duration = 1.0;
     
     // flip the path
     anim.fromValue = circlePathSmall;
     anim.toValue = circlePathBig;
     anim.removedOnCompletion = NO;
     anim.fillMode = kCAFillModeForwards;
     
     [circle addAnimation:anim forKey:nil];
     */
    
    //[UIView animateWithDuration:0.3 animations:^{
        
        
        
    //}];
    
    return spot;
    
}

- (void)animationDidStop:(CABasicAnimation *)theAnimation finished:(BOOL)flag
{
    
    if (flag) {
            
        animating = false;
        height = self.bounds.size.height/2 -self.radius*0.6;
        deltaInWidth = self.bounds.size.width*1.1;
        touchPoint1 = [self creatTouchPointAt:deltaInWidth andHeight:height andRadius:10];
        touchPoint2 = [self creatTouchPointAt:self.bounds.size.width-deltaInWidth andHeight:height andRadius:10];
        self.status.hidden =false;
        self.name.hidden =true;
        // place the status
        float width = 200;
        self.status.text = [self.annotation subtitle];
        [self.status setFrame:CGRectMake(self.bounds.size.width/2 - width/2,self.bounds.size.height/2 -self.radius*1.5, width, 50)];
        [self.status setClipsToBounds:FALSE];
        
       
        [touchPoint1 removeFromSuperlayer];
        [touchPoint2 removeFromSuperlayer];
        [self.layer addSublayer:touchPoint1];
        [self.layer addSublayer:touchPoint2];
        
        [self addSubview:self.status];
        //[self addSubview:touchPoint1Label];
        //[self addSubview:touchPoint2Label];
        [self setNeedsDisplay];
        NSString *path = [theAnimation keyPath];
        [circle setValue:[theAnimation toValue] forKeyPath:path];
        [circle removeAnimationForKey:path];
            
    }
}

-(CAShapeLayer *)createRadialView:(float)radius{

    
        
    UIBezierPath* circlePathBig = [self createRadialBezPath:self.radius];
    
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = circlePathBig.CGPath;
    circle.strokeColor = [[UIColor blackColor] CGColor];
    circle.fillColor   = [[UIColor colorWithWhite:0.4 alpha:0.8] CGColor];
    circle.lineWidth   = 1.2;
    circle.strokeEnd   = 1.2;
    
   
    scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.duration = 0.17;
    scaleAnim.removedOnCompletion = NO;
    animating = true;
    [scaleAnim setDelegate:self];
    [circle addAnimation:scaleAnim forKey:nil];
    
    /*
   
    [CATransaction begin];
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [scaleAnim setDuration:0.5];
    [scaleAnim setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [scaleAnim setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    scaleAnim.removedOnCompletion = NO;
    [CATransaction setCompletionBlock:^{
        animating = false;
        height = self.bounds.size.height/2 -self.radius*0.6;
        deltaInWidth = self.bounds.size.width*1.5;
        touchPoint1 = [self creatTouchPointAt:deltaInWidth andHeight:height andRadius:10];
        touchPoint2 = [self creatTouchPointAt:self.bounds.size.width-deltaInWidth andHeight:height andRadius:10];
        self.status.hidden =false;
        self.name.hidden =true;
        // place the status
        float width = 200;
        self.status.text = [self.annotation subtitle];
        [self.status setFrame:CGRectMake(self.bounds.size.width/2 - width/2,self.bounds.size.height/2 -self.radius*1.5, width, 50)];
        [self.status setClipsToBounds:FALSE];

    }];
    [circle addAnimation:scaleAnim forKey:@"strokeEnd"];
    [CATransaction commit];
    */

    
    return circle;
/*
    CGContextRef gc = UIGraphicsGetCurrentContext();
    CGContextBeginPath(gc);
    CGContextAddArc(gc, 100, 100, 50, -M_PI_2, M_PI_2, 1);
    CGContextClosePath(gc); // could be omitted
    CGContextSetFillColorWithColor(gc, [UIColor cyanColor].CGColor);
    CGContextFillPath(gc);
 */
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
#pragma drawRect
- (void)drawRect:(CGRect)rect
{
    
   
    // draw the symbol
    if ([self touching]) {
               //[UIBezierPath bezierPathWithOvalInRect:CGRectMake(75, 100, 200, 200)];
        NSLog(@"touching");
    
    }else{
        
        NSLog(@"Not touching");
    }
    
    
    // now that we should have a bezierPath that is colored and filled, add it to context
    
    // ?
    //        CGContextRef context = UIGraphicsGetCurrentContext();
    //        CGContextSaveGState(context);
    //        CGContextTranslateCTM(context, 50, 50);
    //        //restore the context
    //        CGContextRestoreGState(context);
    
    
    
    
}
*/

@end

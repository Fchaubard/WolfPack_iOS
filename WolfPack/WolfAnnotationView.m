//
//  WolfAnnotationView.m
//  WolfPack
//
//  Created by Francois Chaubard on 3/10/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "WolfAnnotationView.h"
#import "SVProgressHUD.h"

@implementation WolfAnnotationView

CGPoint startPoint;
NSMutableArray *circle;
//CAShapeLayer *touchPoint1;
//CAShapeLayer *touchPoint2;
NSMutableArray *imagesForCircle;
NSTimeInterval begin;

double height;
double deltaInWidth;
double defaultTouchSize;
bool animating;
double thumbSize;
double vspacer = 10.0;
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
        [self.name sizeToFit];
        
        self.status = [[UILabel alloc] init];
        self.status.text = [self.annotation subtitle];
        self.status.textAlignment=NSTextAlignmentCenter;
        self.status.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.9];
        self.status.layer.cornerRadius = 0.5;
        //self.status.shadowOffset = CGSizeMake(0,3);
        //self.status.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        //[self.status sizeToFit];
        
        [self addSubview:_smallView];
        [self addSubview:_bigView];
        
        
        
        [self addGestureRecognizer:_recognizer];
        thumbSize = 20;
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
    for (CAShapeLayer* shape in circle) {
        [shape removeFromSuperlayer];
    }
    for (UIImageView* im in imagesForCircle) {
        [im removeFromSuperview];
    }
    
    //[touchPoint1 removeFromSuperlayer];
    //[touchPoint2 removeFromSuperlayer];
    
    
    circle = nil;
    
    
    imagesForCircle = [[NSMutableArray alloc] init];
    [imagesForCircle addObject:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubbleSomeone.png"]]];
    [imagesForCircle addObject:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hidden_wolf.png"]]];
    [imagesForCircle addObject:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wolf1.png"]]];
    //  [imagesForCircle addObject:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"missingAvatar.png"]]];
    // [imagesForCircle addObject:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"missingAvatar.png"]]];
    
    circle =[self createRadialView:self.radius withNumberOfPieSlices:3];
    
    for (CAShapeLayer* shape in circle) {
        [self.layer addSublayer:shape];
    }
    
    [self setNeedsDisplay];
    
}

-(void)showSmallView{
    [self.smallView setHidden:false];
    [self.bigView setHidden:true];
    for (CAShapeLayer* shape in circle) {
        [shape removeFromSuperlayer];
    }
    for (UIImageView* im in imagesForCircle) {
        [im removeFromSuperview];
    }
    //[touchPoint1 removeFromSuperlayer];
    //[touchPoint2 removeFromSuperlayer];
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
    begin = [event timestamp];
    
    
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
    //[touchPoint1 removeFromSuperlayer];
    //[touchPoint2 removeFromSuperlayer];
    for (CALayer* shape in imagesForCircle) {
        //[shape removeFromSuperlayer];
    }
    if (!animating) {
        
        
        // Get the current and previous touch locations
        CGPoint newPoint    = [[touches anyObject] locationInView:self];
        //CGPoint prevPoint   = [[touches anyObject] previousLocationInView:self];
        
        /*
         double rad1 = [self calcRadius:newPoint.x-deltaInWidth andDeltY:newPoint.y - height];
         
         touchPoint1 =  [self creatTouchPointAt:deltaInWidth
         andHeight:height
         andRadius:30*[self sigmoidAtValue:rad1]
         andColor:[UIColor colorWithRed:(82.0/255.0) green:(239.0/255.0) blue:(140.0/255.0) alpha:0.9]];
         
         double rad2 = [self calcRadius:newPoint.x-(self.bounds.size.width-deltaInWidth) andDeltY:newPoint.y - height];
         
         touchPoint2 =  [self creatTouchPointAt:(self.bounds.size.width-deltaInWidth)
         andHeight:height
         andRadius:30*[self sigmoidAtValue:rad2]
         andColor:[UIColor colorWithRed:(247.0/255.0) green:(93.0/255.0) blue:(93.0/255.0) alpha:0.9]];
         */
        int touchInLayer = [self getTouchedPieSlice:touches];
        if (touchInLayer==0) //addingFriend
        {
            if (touchState != AddingAFriend) {
                //[touchPoint2 removeFromSuperlayer];
                
                NSLog(@"add %@", [self.annotation title]);
                if ([(Friend *)self.annotation added]==@0) {
                    //[self hotSpotFunctionalityTo:touchPoint1 WithText:@"Add to chat"];
                    [self changeStatusText:@"Add to chat"];
                    
                }else{
                    //[self hotSpotFunctionalityTo:touchPoint1 WithText:@"Remove from chat"];
                    [self changeStatusText:@"Remove from chat"];
                }
                touchState = AddingAFriend;
            }
        }else if(touchInLayer==1){
            if (touchState != HidingFromAFriend) {
                //[touchPoint2 removeFromSuperlayer];
                if ([(Friend *)self.annotation blocked]==@0) {
                    //[self hotSpotFunctionalityTo:touchPoint2 WithText:@"Hide From Friend"];
                    [self changeStatusText:@"Hide From Friend"];
                }else{
                    //[self hotSpotFunctionalityTo:touchPoint2 WithText:@"Unhide From Friend"];
                    [self changeStatusText:@"UnHide From Friend"];
                }
                touchState = HidingFromAFriend;
            }
        }else if(touchInLayer==2){
            
            if (![self.status.text isEqualToString:@"WOLF DANCE!"]) {
                [self changeStatusText:@"WOLF DANCE!"];
            }
            
            
            
        }else{
            // return to normal
            self.status.text = [self.annotation subtitle];
            CGSize status_stringsize = [self.status.text sizeWithFont:[UIFont systemFontOfSize:20]];
            
            
            [self.status setFrame:CGRectMake(self.bounds.size.width/2 - status_stringsize.width/2, self.bounds.size.height/2 -self.radius-status_stringsize.height*1.2 -vspacer,
                                             status_stringsize.width, status_stringsize.height*1.2)];
            [self.status sizeToFit];
            NSLog(@"not in either");
            touchState=MessingAround;
        }
        
        
    }
}
-(int)getTouchedPieSlice:(NSSet *)touches{
    
    int touchInLayer = -1;
    //for (UITouch *touch in touches) {
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    //CGPoint touchLocation =newPoint;
    for (int i=0; i<[circle count]; i++) {
        CAShapeLayer *shape = [circle objectAtIndex:i];
        if (CGPathContainsPoint(shape.path, 0, touchLocation, YES)) {
            // This touch is in this shape layer
            touchInLayer = i;
            [shape setFillColor:[UIColor cyanColor].CGColor];
            NSLog(@"touch in layer %d",i);
            break;
        }else{
            shape.fillColor   = [[UIColor colorWithWhite:0.4 alpha:0.8] CGColor];
        }
        
        
    }
    for (int i=0; i<[circle count]; i++) {
        CAShapeLayer *shape = [circle objectAtIndex:i];
        if (i!=touchInLayer) {
            shape.fillColor   = [[UIColor colorWithWhite:0.4 alpha:0.8] CGColor];
        }
        
        
    }
    //}
    return touchInLayer;
}
-(void)changeStatusText:(NSString *)text{
    
    if (self.status.text!=text) {
        [self fadeOutLabel];
        self.status.text = text;
        CGSize status_stringsize = [self.status.text sizeWithFont:[UIFont systemFontOfSize:20]];
        
        
        [self.status setFrame:CGRectMake(self.bounds.size.width/2 - status_stringsize.width/2,
                                         self.bounds.size.height/2 -self.radius-status_stringsize.height*1.2-vspacer,
                                         status_stringsize.width, status_stringsize.height*1.2)];
        [self.status sizeToFit];
        [self fadeInLabel];
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
    [self changeStatusText:text];
    
}
-(double)calcRadius:(double)deltX
           andDeltY:(double)deltY{
    
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
    
    int touchInLayer = [self getTouchedPieSlice:touches];
    
    
    if ( ([event timestamp] -begin)>0.6) {
        
        
        
        if (touchInLayer==0) {
            if ([(Friend *)self.annotation added]==@0) {
                NSLog(@"add %@", [self.annotation title]);
                [(Friend *)self.annotation setAdded:@1];
                [self addFriendOnServer];
                [SVProgressHUD showSuccessWithStatus:@"Added"];
            }else{
                NSLog(@"unadd %@", [self.annotation title]);
                [(Friend *)self.annotation setAdded:@0];
                [self removeFriendOnServer];
                [SVProgressHUD showSuccessWithStatus:@"Removed"];
            }
        }
        else if(touchInLayer==1){
            if ([(Friend *)self.annotation blocked]==@0) {
                NSLog(@"block %@", [self.annotation title]);
                [(Friend *)self.annotation setBlocked:@1];
                [self hideFromFriendOnServer];
                
                [SVProgressHUD showSuccessWithStatus:@"Hidden From"];
            }else{
                NSLog(@"unblock %@", [self.annotation title]);
                [(Friend *)self.annotation setBlocked:@0];
                [self unhideFromFriendOnServer];
                
                [SVProgressHUD showSuccessWithStatus:@"Unhidden From"];
            }
            
        }
    }
    touchState = NotTouching;
    [self showSmallView];
    if(touchInLayer==2){
        
        [self spinem];
        [SVProgressHUD showSuccessWithStatus:@"WOLF DANCE!"];
        
        
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // check for all the spots we want to look at!
    animating = false;
    NSLog(@"ended");
    
    
    int touchInLayer = [self getTouchedPieSlice:touches];
    if ( ([event timestamp] -begin)>0.6) {
        
        
        
        if (touchInLayer==0) {
            if ([(Friend *)self.annotation added]==@0) {
                NSLog(@"add %@", [self.annotation title]);
                [(Friend *)self.annotation setAdded:@1];
                [self addFriendOnServer];
                [SVProgressHUD showSuccessWithStatus:@"Added"];
            }else{
                NSLog(@"unadd %@", [self.annotation title]);
                [(Friend *)self.annotation setAdded:@0];
                [self removeFriendOnServer];
                [SVProgressHUD showSuccessWithStatus:@"Removed"];
            }
        }
        else if(touchInLayer==1){
            if ([(Friend *)self.annotation blocked]==@0) {
                NSLog(@"block %@", [self.annotation title]);
                [(Friend *)self.annotation setBlocked:@1];
                [self hideFromFriendOnServer];
                
                [SVProgressHUD showSuccessWithStatus:@"Hidden From"];
            }else{
                NSLog(@"unblock %@", [self.annotation title]);
                [(Friend *)self.annotation setBlocked:@0];
                [self unhideFromFriendOnServer];
                
                [SVProgressHUD showSuccessWithStatus:@"Unhidden From"];
            }
            
        }
    }
    touchState = NotTouching;
    [self showSmallView];
    
    if(touchInLayer==2){
        
        [self spinem];
        [SVProgressHUD showSuccessWithStatus:@"WOLF DANCE!"];
        
    }
}

-(void)spinem{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.smallView setTransform:CGAffineTransformRotate(self.smallView.transform,3.14159)];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.5 animations:^{
            [self.smallView setTransform:CGAffineTransformRotate(self.smallView.transform,3.14159)];
        }];
    }];
}

-(void)addFriendOnServer{
    [self updateServerFriendStatus:false withValue:true];
}
-(void)removeFriendOnServer{
    [self updateServerFriendStatus:false withValue:false];
}
-(void)hideFromFriendOnServer{
    [self updateServerFriendStatus:true withValue:true];
}
-(void)unhideFromFriendOnServer{
    [self updateServerFriendStatus:true withValue:false];
}
-(void)updateServerFriendStatus:(BOOL)addedIsZeroHideIsOne withValue:(BOOL)value{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd*HH:mm:ss"];
    NSString *dateString = [DateFormatter stringFromDate:[NSDate date]];
    dispatch_queue_t fetchQ = dispatch_queue_create("Update Friend Status", NULL);
    dispatch_async(fetchQ, ^{
        NSString *valueString = value?@"true":@"false";
        
        NSString *sessionid =[[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
        NSString *str;
        
        // Adding
        if (!addedIsZeroHideIsOne) {
            str = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/addfriendtochatjson.php?session=%@&friendid=%@&add=%@&date=%@",sessionid, [(Friend *)self.annotation userID], valueString, dateString];
            
            // Hiding
        }else{
            str = [NSString stringWithFormat:@"http://hungrylikethewolves.com/serverlets/hidefromfriendjson.php?session=%@&friendid=%@&hide=%@&date=%@",sessionid, [(Friend *)self.annotation userID],valueString, dateString];
        }
        
        
        
        
        NSURL *URL = [NSURL URLWithString:str];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        NSError *error = [[NSError alloc] init];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSString * string = [[NSString alloc] initWithData:responseData encoding:
                             NSASCIIStringEncoding];
        
        if (string.intValue == 1) {
            NSLog(@"asdfa");
        } else {
            NSLog(@"error");
        }
    });
    return;
    
}



#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

-(UIBezierPath *)createRadialBezPath:(double)radius
                              number:(int)number
                                  of:(int)total{
    
    double angle = DEGREES_TO_RADIANS(45); // size of a pie slice
    double spacer = DEGREES_TO_RADIANS(0);
    double hspacer = 4.0;
    
    
    double totalAngle = (total+1)*(angle+spacer) - spacer;
    if (totalAngle<=M_PI) {
        
        double angleOfXAxis = ((M_PI) - totalAngle)/2;
        
        UIBezierPath* circlePath =[UIBezierPath bezierPath];
        double startX = self.bounds.size.width/2 +(total-number)*hspacer;
        double startY = self.bounds.size.height/2 -vspacer;
        [circlePath moveToPoint:CGPointMake( startX, startY)];
        
        double firstX =startX-radius*cos(angleOfXAxis+(total-number)*(angle+spacer));
        double firstY =startY-radius*sin(angleOfXAxis+(total-number)*(angle+spacer));
        
        
        [circlePath addLineToPoint:CGPointMake(firstX,firstY)];
        
        [circlePath addArcWithCenter:CGPointMake(startX, startY)
                              radius:radius
                          startAngle:DEGREES_TO_RADIANS(180)+angleOfXAxis+(total-number)*(angle+spacer)
                            endAngle:DEGREES_TO_RADIANS(180)+angleOfXAxis+(total-number+1)*(angle) clockwise:YES];
        double secondX = circlePath.currentPoint.x;
        double secondY = circlePath.currentPoint.y;
        
        
        
        [circlePath addLineToPoint:CGPointMake(startX, startY)];
        //[circlePath addLineToPoint:CGPointMake( self.bounds.size.width/2, self.bounds.size.height/2-self.radius)];
        
        double centerOfTriangleX = (startX+firstX+secondX)/3;
        double centerOfTriangleY = (startY+firstY+secondY)/3;
        double widthOfImage = 40;
        double heightOfImage = 30;
        
        [[imagesForCircle objectAtIndex:number] setFrame:CGRectMake(centerOfTriangleX-widthOfImage/2, centerOfTriangleY-heightOfImage/2, widthOfImage, heightOfImage)];
        return circlePath;
        
    }else{
        // handle a biggg radial view..
        return nil;
    }
    
}

-(CAShapeLayer *)creatTouchPointAt:(double)x
                         andHeight:(double)y
                         andRadius:(double)rad
                          andColor:(UIColor *)color{
    UIBezierPath* circlePath =[UIBezierPath bezierPathWithArcCenter:CGPointMake(x, y) radius:rad startAngle:DEGREES_TO_RADIANS(0.1) endAngle:DEGREES_TO_RADIANS(0) clockwise:YES];
    
    CAShapeLayer *spot = [CAShapeLayer layer];
    spot.path = circlePath.CGPath;
    spot.strokeColor = [[UIColor blackColor] CGColor];
    spot.fillColor   = [color CGColor];
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
        /*touchPoint1 = [self creatTouchPointAt:deltaInWidth
         andHeight:height
         andRadius:10
         andColor:[UIColor colorWithRed:(82.0/255.0) green:(239.0/255.0) blue:(140.0/255.0) alpha:0.9]];
         touchPoint2 = [self creatTouchPointAt:self.bounds.size.width-deltaInWidth
         andHeight:height
         andRadius:10
         andColor:[UIColor colorWithRed:(247.0/255.0) green:(93.0/255.0) blue:(93.0/255.0) alpha:0.9]];
         */
        self.status.hidden =false;
        self.name.hidden =true;
        // place the status at the top
        
        
        self.status.text = [self.annotation subtitle];
        CGSize status_stringsize = [self.status.text sizeWithFont:[UIFont systemFontOfSize:20]];
        
        
        [self.status setFrame:CGRectMake(self.bounds.size.width/2 - status_stringsize.width/2,
                                         self.bounds.size.height/2 -self.radius-status_stringsize.height*1.2-vspacer,
                                         status_stringsize.width, status_stringsize.height*1.2)];
        [self.status sizeToFit];
        
        [self.status setClipsToBounds:FALSE];
        
        
        /*[touchPoint1 removeFromSuperlayer];
         [touchPoint2 removeFromSuperlayer];
         [self.layer addSublayer:touchPoint1];
         [self.layer addSublayer:touchPoint2];
         */
        
        
        for (UIImageView* im in imagesForCircle) {
            [im removeFromSuperview];
        }
        for (UIImageView* im in imagesForCircle) {
            [self addSubview:im];
        }
        [self addSubview:self.status];
        
        //[self addSubview:touchPoint1Label];
        //[self addSubview:touchPoint2Label];
        [self setNeedsDisplay];
        NSString *path = [theAnimation keyPath];
        for (CAShapeLayer* shape in circle) {
            [shape setValue:[theAnimation toValue] forKeyPath:path];
            [shape removeAnimationForKey:path];
        }
        
        
    }
}

-(NSMutableArray *)createRadialView:(float)radius withNumberOfPieSlices:(int)numPieSlices{
    
    
    NSMutableArray *pieSlices = [[NSMutableArray alloc] initWithCapacity:numPieSlices];
    
    for (int i=0; i<numPieSlices; i++) {
        // returns an array of Bez Paths
        UIBezierPath* circlePathBig = [self createRadialBezPath:self.radius
                                                         number:i
                                                             of:(numPieSlices-1)];
        
        
        CAShapeLayer *pieSlice = [CAShapeLayer layer];
        pieSlice.path = circlePathBig.CGPath;
        pieSlice.strokeColor = [[UIColor blackColor] CGColor];
        pieSlice.fillColor   = [[UIColor colorWithWhite:0.4 alpha:0.8] CGColor];
        pieSlice.lineWidth   = 1.2;
        pieSlice.strokeEnd   = 1.2;
        
        
        
        scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
        scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim.duration = 0.2;
        scaleAnim.removedOnCompletion = NO;
        animating = true;
        [scaleAnim setDelegate:self];
        [pieSlice addAnimation:scaleAnim forKey:nil];
        [pieSlices addObject:pieSlice];
        
    }
    
    
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
    
    
    return pieSlices;
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

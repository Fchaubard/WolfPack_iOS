//
//  HorizontalTextScroller.m
//  iPhone Practice 1
//
//  Created by Francois Chaubard on 4/30/13.
//
//

#import "HorizontalTextScroller.h"

@implementation HorizontalTextScroller

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
   
    return self;
}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    if(self.bigViewBoolean)
    {
        //Show small view
        self.bigViewBoolean = false;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            NSArray *cgrects = [self horizontalCGRects];
            for (UIView *view in self.subviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    [(UIButton *)view setFrame:[[cgrects objectAtIndex:view.tag] CGRectValue]];
                }else if([view isKindOfClass:[UILabel class]]){
                    [view removeFromSuperview];
                }
            }
            
            
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                 [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height/4)];
                
                
            } completion:^(BOOL finished) {
                
                
                
            }
             ];
            
           
        }
         ];
        
    }else{
        //Show big view
        self.bigViewBoolean = true;
        [UIView animateWithDuration:0.25 animations:^{
            
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height*4)];
            
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                NSArray *cgrects = [self verticalCGRects];
                
                // set the btn cgs
                for (UIButton *btn in self.subviews) {
                    if ([btn isKindOfClass:[UIButton class]]) {
                        CGRect cg = [[cgrects objectAtIndex:btn.tag] CGRectValue];
                        
                        [btn setFrame:cg];
                      
                        
                    }
                }
                
                
            } completion:^(BOOL finished) {
                
                //create the labels
                NSArray *cgrects = [self verticalCGRects];
                for (UIView *btn in self.subviews) {
                    if([btn isKindOfClass:[UIButton class]]){
                        CGRect cg = [[cgrects objectAtIndex:btn.tag] CGRectValue];
                        
                        
                        CGSize stringsize = [[self.text objectAtIndex:btn.tag] sizeWithFont:[UIFont systemFontOfSize:20]];
                        int h = 1.4*stringsize.height; // for the + button to be consistent
                        // Start Populating the btn
                        CGSize status_stringsize = [[self.statuses objectAtIndex:btn.tag] sizeWithFont:[UIFont systemFontOfSize:20]];
                        int hstat = 1.4*stringsize.height;
                        
                        UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(cg.origin.x+10, cg.origin.y+h, stringsize.width, hstat)];
                        
                        [status setText:[self.statuses objectAtIndex:btn.tag]];
                        [status setAlpha:0.0];
                        [status setBackgroundColor:[UIColor clearColor]];
                        
                        [self addSubview:status];
                        
                    }
                }

                [UIView animateWithDuration:0.25 animations:^{
                    // fade the labels in
                    for (UIView *label in self.subviews) {
                        if([label isKindOfClass:[UILabel class]]){
                            [label setAlpha:0.8];
                        }
                    }

                } completion:^(BOOL finished) {
                    
                    
                    
                }
                 ];

                
                
            }
             ];
            
        }
         ];
        
    }
}


-(void)initWithNames:(NSArray *)array
         andStatuses:(NSArray *)status_array
        buttonHeight:(int)buttonheight
             spacing:(int)spacing
       topOfScroller:(int)topheight{
    
    [self setBackgroundColor:[UIColor grayColor]];
    self.text = array;
    self.statuses = status_array;
    self.buttonHeight = buttonheight;
    self.spacing = spacing;
    self.distanceFromTopOfScroller = topheight;
    self.bigViewBoolean = FALSE;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
    
    for(UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    
    NSArray *cgRects = [self horizontalCGRects];

    // populate button array
    for(int j = 0; j<[self.text count]; j++){
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        CGSize stringsize = [[self.text objectAtIndex:j] sizeWithFont:[UIFont systemFontOfSize:20]];
        int h = 1.4*stringsize.height; // for the + button to be consistent
        // Start Populating the btn
        btn.bounds = CGRectMake(0, 0, stringsize.width, h);
        btn.tag = j;
        [btn setTitle:[self.text objectAtIndex:j] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setEnabled:FALSE];
        CGRect cg = [[cgRects objectAtIndex:j] CGRectValue];
        
        [btn setFrame:cg];
      
        [self addSubview:btn];
      
    }
    
    
}

-(void)refreshScroller:(NSMutableArray *)array{
    for(UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
 
}


// draw button with dynamic width and height
-(NSMutableArray *)horizontalCGRects
{
    
    NSMutableArray *cgRects = [[NSMutableArray alloc] init];
    int h = self.buttonHeight; //35;  // height of buttons
    int x = self.spacing;// 20;  // space between buttons
    int d = self.distanceFromTopOfScroller; //10; // distance buttons are from the top of the scrollview
//    int hideButton = 35; // width of the hideButton
    
    // Insert hideButton
   /* UIButton *hidebtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    
    [hidebtn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
    [hidebtn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateDisabled];
    [hidebtn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateSelected];
    [hidebtn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateHighlighted];
    [hidebtn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:(UIControlStateHighlighted | UIControlStateSelected)];
    
    hidebtn.frame = CGRectMake(x, d, hideButton, h);
    hidebtn.bounds = CGRectMake(0, 0, hideButton, h);
    //[hidebtn setImage:[self scaleAndRotateImage:[UIImage imageNamed:@"basicbutton.png"]] forState:UIControlStateNormal];
    [hidebtn addTarget:self action:@selector(hideScroll:) forControlEvents:UIControlEventTouchUpInside];
    //[hidebtn setTitle:@"::" forState:UIControlStateNormal];
    //[hidebtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //[hidebtn setBackgroundColor:[UIColor redColor]];
    [self addSubview:hidebtn];
    
    */
    
    // Start populating the User Content
    int contentSize = 2*x;//2*x+hideButton;
    int numberOfButtons = [self.text count]; // number of buttons
    //UIButton *buttons[numberOfButtons];
    for(int j = 0; j<numberOfButtons; j++){
        
        CGSize stringsize = [[self.text objectAtIndex:j] sizeWithFont:[UIFont systemFontOfSize:20]];
        int h = 1.4*stringsize.height; // for the + button to be consistent
        // Start Populating the btn
        [cgRects addObject:[NSValue valueWithCGRect:CGRectMake(contentSize,d,stringsize.width, h)]];
        contentSize += stringsize.width + x;
        
    }
    [self setScrollEnabled:TRUE];
    [self setContentSize:CGSizeMake(contentSize+x+h,h)];
    self.clipsToBounds = YES;
    /*UIButton *btn = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    btn.frame = CGRectMake(contentSize, d, h, h);
    btn.bounds = CGRectMake(0, 0, h, h);
    //[btn setImage:[self scaleAndRotateImage:[UIImage imageNamed:@"basicbutton.png"]] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addTime:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"+" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self addSubview:btn];
    
    [buttonView setContentSize:CGSizeMake(contentSize+x+h, buttonView.bounds.size.height)];
    buttonView.clipsToBounds = YES;*/
    return cgRects;
}

-(NSMutableArray *)verticalCGRects
{
    
    NSMutableArray *cgRects = [[NSMutableArray alloc] init];
    int h = self.buttonHeight; //35;  // height of buttons
    int x = self.spacing;// 20;  // space between buttons
    int d = self.distanceFromTopOfScroller; //10; // distance buttons are from the top of the scrollview
    int labelSpacing =20;
    //    int hideButton = 35; // width of the hideButton
    
    // Insert hideButton
    /* UIButton *hidebtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
     
     [hidebtn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
     [hidebtn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateDisabled];
     [hidebtn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateSelected];
     [hidebtn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateHighlighted];
     [hidebtn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:(UIControlStateHighlighted | UIControlStateSelected)];
     
     hidebtn.frame = CGRectMake(x, d, hideButton, h);
     hidebtn.bounds = CGRectMake(0, 0, hideButton, h);
     //[hidebtn setImage:[self scaleAndRotateImage:[UIImage imageNamed:@"basicbutton.png"]] forState:UIControlStateNormal];
     [hidebtn addTarget:self action:@selector(hideScroll:) forControlEvents:UIControlEventTouchUpInside];
     //[hidebtn setTitle:@"::" forState:UIControlStateNormal];
     //[hidebtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
     //[hidebtn setBackgroundColor:[UIColor redColor]];
     [self addSubview:hidebtn];
     
     */
   
    // Start populating the User Content
    int contentSizeVert = x;//2*x+hideButton;
    int numberOfButtons = [self.text count]; // number of buttons
    //UIButton *buttons[numberOfButtons];
    for(int j = 0; j<numberOfButtons; j++){
        
        CGSize stringsize = [[self.text objectAtIndex:j] sizeWithFont:[UIFont systemFontOfSize:20]];
        int h = 1.4*stringsize.height; // for the + button to be consistent
        // Start Populating the btn
        CGSize status_stringsize = [[self.statuses objectAtIndex:j] sizeWithFont:[UIFont systemFontOfSize:20]];
        int hstat = 1.4*stringsize.height;
        [cgRects addObject:[NSValue valueWithCGRect:CGRectMake(5,contentSizeVert,stringsize.width, h)]];
        contentSizeVert += h + d + hstat;
        
    }
    [self setScrollEnabled:TRUE];
    [self setContentSize:CGSizeMake(320, contentSizeVert+x)];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 320, self.frame.size.height)];
    self.clipsToBounds = YES;
    /*UIButton *btn = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
     btn.frame = CGRectMake(contentSize, d, h, h);
     btn.bounds = CGRectMake(0, 0, h, h);
     //[btn setImage:[self scaleAndRotateImage:[UIImage imageNamed:@"basicbutton.png"]] forState:UIControlStateNormal];
     [btn addTarget:self action:@selector(addTime:) forControlEvents:UIControlEventTouchUpInside];
     [btn setTitle:@"+" forState:UIControlStateNormal];
     [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
     [self addSubview:btn];
     
     [buttonView setContentSize:CGSizeMake(contentSize+x+h, buttonView.bounds.size.height)];
     buttonView.clipsToBounds = YES;*/
    return cgRects;
}

-(void)load:(id)sender{
    NSLog(@"loading");
}



@end

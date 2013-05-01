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
-(void)initWithArray:(NSMutableArray *)array buttonHeight:(int)buttonheight spacing:(int)spacing topOfScroller:(int)topheight{
    self.text = array;
    self.buttonHeight = buttonheight;
    self.spacing = spacing;
    self.distanceFromTopOfScroller = topheight;
    [self drawbuttons];
    
}

-(void)refreshScroller:(NSMutableArray *)array{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

// draw button with dynamic width and height
-(void)drawbuttons
{
    
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
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        CGSize stringsize = [[self.text objectAtIndex:j] sizeWithFont:[UIFont systemFontOfSize:20]];
        
        
        int h = 1.4*stringsize.height; // for the + button to be consistent
        // Start Populating the btn
        [btn setFrame:CGRectMake(contentSize,d,stringsize.width, h)];
        btn.bounds = CGRectMake(0, 0, stringsize.width, h);
        //[btn setImage:[self scaleAndRotateImage:[UIImage imageNamed:@"basicbutton.png"]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(load:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = j;
        [btn setTitle:[self.text objectAtIndex:j] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setEnabled:FALSE];
        [self addSubview:btn];
        contentSize += stringsize.width + x;
        [self setScrollEnabled:TRUE];
        [self setContentSize:CGSizeMake(contentSize+x+h, self.bounds.size.height)];
        self.clipsToBounds = YES;
    }
    
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
    
}

-(void)load:(id)sender{
    NSLog(@"loading");
}



@end

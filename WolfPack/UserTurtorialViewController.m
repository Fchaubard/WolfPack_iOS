//
//  UserTurtorialViewController.m
//  WolfPack
//
//  Created by Jesus Mora on 6/1/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "UserTurtorialViewController.h"

@interface UserTurtorialViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButton;

@property (strong, nonatomic) NSArray *imageArray;

@end

@implementation UserTurtorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	ULTFriendsList *friendsList = (ULTFriendsList *)(segue.destinationViewController);
	friendsList.originView = @"tutorial";
}

- (void)initScrollView
{	
	self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.pageControl.frame.size.height)];
	
	[self.scrollView setPagingEnabled:true];
	[self.scrollView setScrollEnabled:true];
	[self.scrollView setScrollsToTop:false];
	[self.scrollView setDelegate:self];
	[self.scrollView setShowsHorizontalScrollIndicator:false];
	[self.scrollView setShowsVerticalScrollIndicator:false];
	
	self.imageArray = [[NSArray alloc] initWithObjects:@"image1.png", @"image2.png", @"image3.png", @"image4.png", @"image5.png", @"image6.png", nil];

	int imageArrayLen = [self.imageArray count];
	
	[self.pageControl setNumberOfPages:imageArrayLen];
	
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * imageArrayLen, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.pageControl.frame.size.height);
	
	for(int i = 0; i < imageArrayLen; i++) {
		CGRect page;
		
        page.origin.x = self.scrollView.frame.size.width * i;
        page.origin.y = 0;
        page.size = self.scrollView.frame.size;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:page];
		
        imageView.image = [UIImage imageNamed:[self.imageArray objectAtIndex:i]];
		[self.scrollView addSubview:imageView];
    }
	
	[self.view addSubview:self.scrollView];
	[self.view addSubview:self.pageControl];
}

- (void)initPageController
{
	CGFloat pcHeight = 36;
	
	self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - pcHeight, self.view.frame.size.width, pcHeight)];
	
	[self.pageControl setCurrentPage:0];
	[self.pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
	[self.pageControl setPageIndicatorTintColor:[UIColor grayColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self initPageController];
	[self initScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
	CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
		
	if(page == ([self.imageArray count] - 1)) {
		[self.barButton setTitle:@"Done"];
	} else {
		[self.barButton setTitle:@"Skip"];
	}
}

@end

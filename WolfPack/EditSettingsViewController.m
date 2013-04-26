//
//  EditSettingsViewController.m
//  WolfPack
//
//  Created by Jesus Mora on 4/24/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "EditSettingsViewController.h"

@interface EditSettingsViewController ()
@property UILabel *prop1Label;
@property UILabel *prop2Label;
@property UILabel *prop3Label;
@property UITextField *prop1TextField;
@property UITextField *prop2TextField;
@property UITextField *prop3TextField;
@property CGFloat xIndent;
@property CGFloat yIndent;
@property CGFloat textWidth;
@property CGFloat textHeight;
@property CGFloat scrnW;
@property CGFloat spacing;
@end

@implementation EditSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.view endEditing:true];
	return true;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)valueChanged:(id)sender
{
	self.property1 = self.prop1TextField.text;
	self.property2 = self.prop2TextField.text;
	self.property3 = self.prop3TextField.text;
}

- (void)editEmailTools
{
	self.prop1Label.text = @"New Email";
	self.prop1TextField.placeholder = @"Required Field";
	
	self.prop2Label.text = @"Confirm New Email";
	self.prop2TextField.placeholder = @"Required Field";
}

- (void)editPasswordTools
{
	self.prop1Label.text = @"Current Password";
	self.prop1TextField.placeholder = @"Required Field";
	
	self.prop2Label.text = @"New Password";
	self.prop2TextField.placeholder = @"Required Field";
	
	CGFloat prop3LabYIndent = self.yIndent + 2 * self.textHeight + self.prop1TextField.frame.size.height + self.prop2TextField.frame.size.height + 4 * self.spacing;
	self.prop3Label = [[UILabel alloc] initWithFrame:CGRectMake(self.xIndent, prop3LabYIndent, self.textWidth, self.textHeight)];
	self.prop3Label.text = @"Confirm New Password";
	[self.view addSubview:self.prop3Label];
	
	CGFloat prop3TfY = prop3LabYIndent + self.textHeight + self.spacing;
	self.prop3TextField = [[UITextField alloc] initWithFrame:CGRectMake(self.xIndent, prop3TfY, self.scrnW - 2 * self.xIndent, 1.5 * self.textHeight)];
	self.prop3TextField.borderStyle = UITextBorderStyleRoundedRect;
	self.prop3TextField.placeholder = @"Required Field";
	self.prop3TextField.clearButtonMode = UITextFieldViewModeAlways;
	self.prop3TextField.delegate = self;
	[self.prop3TextField addTarget:self
							action:@selector(valueChanged:)
				  forControlEvents:UIControlEventEditingChanged];
	
	[self.view addSubview:self.prop3TextField];
}

- (void)editNameTools
{
	self.prop1Label.text = @"First Name";
	self.prop1TextField.text = self.property1;

	self.prop2Label.text = @"Last Name";
	self.prop2TextField.text = self.property2;
}

- (void)editTools
{
	self.prop1Label = [[UILabel alloc] initWithFrame:CGRectMake(self.xIndent, self.yIndent, self.textWidth, self.textHeight)];
	[self.view addSubview:self.prop1Label];
	
	CGFloat prop1TfY = self.yIndent + self.prop1Label.frame.size.height + self.spacing;
	self.prop1TextField = [[UITextField alloc] initWithFrame:CGRectMake(self.xIndent, prop1TfY, self.scrnW - 2 * self.xIndent, 1.5 * self.textHeight)];
	self.prop1TextField.borderStyle = UITextBorderStyleRoundedRect;
	self.prop1TextField.placeholder = self.property1;
	self.prop1TextField.clearButtonMode = UITextFieldViewModeAlways;
	self.prop1TextField.delegate = self;
	[self.prop1TextField addTarget:self
							action:@selector(valueChanged:)
				  forControlEvents:UIControlEventEditingChanged];

	[self.view addSubview:self.prop1TextField];
	
	CGFloat prop1LabelY = self.prop1Label.frame.origin.y + self.prop1Label.frame.size.height + 2 * self.spacing + self.prop1TextField.frame.size.height;
	
	self.prop2Label = [[UILabel alloc] initWithFrame:CGRectMake(self.xIndent, prop1LabelY, self.textWidth, self.textHeight)];
	[self.view addSubview:self.prop2Label];
	
	CGFloat prop2TfY = prop1LabelY + self.prop2Label.frame.size.height + self.spacing;
	
	self.prop2TextField = [[UITextField alloc] initWithFrame:CGRectMake(self.xIndent, prop2TfY, self.scrnW - 2 * self.xIndent, 1.5 * self.textHeight)];
	self.prop2TextField.borderStyle = UITextBorderStyleRoundedRect;
	self.prop2TextField.placeholder = self.property2;
	self.prop2TextField.clearButtonMode = UITextFieldViewModeAlways;
	
	self.prop2TextField.delegate = self;
	[self.prop2TextField addTarget:self
							action:@selector(valueChanged:)
				  forControlEvents:UIControlEventEditingChanged];

	[self.view addSubview:self.prop2TextField];
}

- (void)viewWillAppear:(BOOL)animated
{
	self.xIndent = 10;
	self.spacing = 10;
	self.yIndent = 10;
	self.scrnW = self.view.frame.size.width;
	self.textWidth = self.scrnW;
	self.textHeight = 21;
	[self editTools];
	if([self.editType isEqualToString:@"editName"]) {
		[self editNameTools];
	} else if([self.editType isEqualToString:@"editPassword"]) {
		[self editPasswordTools];
	} else if([self.editType isEqualToString:@"editEmail"]) {
		[self editEmailTools];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
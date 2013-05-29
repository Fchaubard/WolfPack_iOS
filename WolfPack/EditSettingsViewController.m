//
//  EditSettingsViewController.m
//  WolfPack
//
//  Created by Jesus Mora on 4/24/13.
//  Copyright (c) 2013 Francois Chaubard. All rights reserved.
//

#import "EditSettingsViewController.h"

@interface EditSettingsViewController ()
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *prop1Label, *prop2Label, *prop3Label;
@property (strong, nonatomic) UITextField *prop1TextField, *prop2TextField, *prop3TextField;
@property CGFloat submitButtonY, scrnW, spacing;
@property CGFloat xIndent, yIndent;
@property CGFloat textWidth, textHeight;
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

- (void)adjustView:(int)textFieldFocus
{
	CGRect rect;
	if(textFieldFocus == 1) {
		rect = CGRectMake(0, 0, self.scrnW, self.view.frame.size.height);
	} else if(textFieldFocus == 2) {
		CGFloat newY = self.view.frame.origin.y - self.yIndent - self.prop1Label.frame.size.height;
		rect = CGRectMake(0, newY, self.scrnW, self.view.frame.size.height);
	} else if(textFieldFocus == 3) {
		CGFloat newY = self.view.frame.origin.y - 2*self.spacing - self.prop1TextField.frame.size.height - self.prop2Label.frame.size.height;
		rect = CGRectMake(0, newY, self.scrnW, self.view.frame.size.height);
	}
	[UIView transitionWithView:self.view
					  duration:0.2
					   options:UIViewAnimationCurveEaseIn
					animations:^{
						[self.view setFrame:rect];
					}
					completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if(textField.tag == self.prop1TextField.tag) {
		[self.prop1TextField  setEnabled:false];
		[self.prop2TextField setEnabled:true];
		[self.prop2TextField becomeFirstResponder];
		[self adjustView:self.prop2TextField.tag];
	} else if(textField.tag == self.prop2TextField.tag) {
		if([self.editType isEqualToString:@"resetPassword"]) {
			[self.prop2TextField setEnabled:false];
			[self.prop3TextField setEnabled:true];
			[self.prop3TextField becomeFirstResponder];
			[self adjustView:self.prop3TextField.tag];
		} else {
			[self.prop1TextField setEnabled:true];
			[self.prop2TextField setEnabled:false];
			[self.prop2TextField resignFirstResponder];
			[self adjustView:self.prop1TextField.tag];
		}
	} else {
		[self.prop1TextField setEnabled:true];
		[self.prop3TextField setEnabled:false];
		[self.prop3TextField resignFirstResponder];
		[self adjustView:self.prop1TextField.tag];
	}
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
	self.prop1TextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.prop1TextField.keyboardType = UIKeyboardTypeEmailAddress;
	
	self.prop2Label.text = @"Confirm New Email";
	self.prop2TextField.placeholder = @"Required Field";
	self.prop2TextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.prop2TextField.keyboardType = UIKeyboardTypeEmailAddress;
}

- (void)resetPasswordTools
{
	self.prop1Label.text = @"Current Password";
	self.prop1TextField.placeholder = @"Required Field";
	self.prop1TextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.prop1TextField.secureTextEntry = true;
	
	self.prop2Label.text = @"New Password";
	self.prop2TextField.placeholder = @"Required Field";
	self.prop2TextField.returnKeyType = UIReturnKeyNext;
	self.prop2TextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.prop2TextField.secureTextEntry = true;
	
	CGFloat prop3LabYIndent = self.yIndent + 2 * self.textHeight + self.prop1TextField.frame.size.height + self.prop2TextField.frame.size.height + 4 * self.spacing;
	self.prop3Label = [[UILabel alloc] initWithFrame:CGRectMake(self.xIndent, prop3LabYIndent, self.textWidth, self.textHeight)];
	self.prop3Label.text = @"Confirm New Password";
	self.prop3Label.textColor = [UIColor whiteColor];
	self.prop3Label.backgroundColor = [UIColor clearColor];
	
	[self.view addSubview:self.prop3Label];
	
	CGFloat prop3TfY = prop3LabYIndent + self.textHeight + self.spacing;
	self.prop3TextField = [[UITextField alloc] initWithFrame:CGRectMake(self.xIndent, prop3TfY, self.scrnW - 2 * self.xIndent, 1.5 * self.textHeight)];
	self.prop3TextField.borderStyle = UITextBorderStyleRoundedRect;
	self.prop3TextField.placeholder = @"Required Field";
	self.prop3TextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
	self.prop3TextField.delegate = self;
	self.prop3TextField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.prop3TextField.returnKeyType = UIReturnKeyDone;
	self.prop3TextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.prop3TextField.secureTextEntry = true;
	self.prop3TextField.tag = 3;
	[self.prop3TextField setEnabled:false];
	[self.prop3TextField addTarget:self
							action:@selector(valueChanged:)
				  forControlEvents:UIControlEventEditingChanged];
	
	[self.view addSubview:self.prop3TextField];
	
	self.submitButtonY = prop3TfY + self.prop3TextField.frame.size.height + self.spacing;
}

- (void)editNameTools
{
	self.prop1Label.text = @"First Name";
	self.prop1TextField.placeholder = self.property1;
	self.property1 = @"";
    
	self.prop2Label.text = @"Last Name";
	self.prop2TextField.placeholder = self.property2;
	self.property2 = @"";
}

- (void)editTools
{
	self.prop1Label = [[UILabel alloc] initWithFrame:CGRectMake(self.xIndent, self.yIndent, self.textWidth, self.textHeight)];
	self.prop1Label.textColor = [UIColor whiteColor];
	self.prop1Label.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.prop1Label];
	
	CGFloat prop1TfY = self.yIndent + self.prop1Label.frame.size.height + self.spacing;
	self.prop1TextField = [[UITextField alloc] initWithFrame:CGRectMake(self.xIndent, prop1TfY, self.scrnW - 2 * self.xIndent, 1.5 * self.textHeight)];
	self.prop1TextField.borderStyle = UITextBorderStyleRoundedRect;
	self.prop1TextField.placeholder = self.property1;
	self.prop1TextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
	self.prop1TextField.delegate = self;
	self.prop1TextField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.prop1TextField.returnKeyType = UIReturnKeyNext;
	self.prop1TextField.tag = 1;
	[self.prop1TextField becomeFirstResponder];
	[self.prop1TextField setEnabled:true];
	[self.prop1TextField addTarget:self
							action:@selector(valueChanged:)
				  forControlEvents:UIControlEventEditingChanged];
	
	[self.view addSubview:self.prop1TextField];
	
	CGFloat prop1LabelY = self.prop1Label.frame.origin.y + self.prop1Label.frame.size.height + 2 * self.spacing + self.prop1TextField.frame.size.height;
	
	self.prop2Label = [[UILabel alloc] initWithFrame:CGRectMake(self.xIndent, prop1LabelY, self.textWidth, self.textHeight)];
	self.prop2Label.textColor = [UIColor whiteColor];
	self.prop2Label.backgroundColor = [UIColor clearColor];
	
	[self.view addSubview:self.prop2Label];
	
	CGFloat prop2TfY = prop1LabelY + self.prop2Label.frame.size.height + self.spacing;
	
	self.prop2TextField = [[UITextField alloc] initWithFrame:CGRectMake(self.xIndent, prop2TfY, self.scrnW - 2 * self.xIndent, 1.5 * self.textHeight)];
	self.prop2TextField.borderStyle = UITextBorderStyleRoundedRect;
	self.prop2TextField.placeholder = self.property2;
	self.prop2TextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
	
	self.prop2TextField.delegate = self;
	self.prop2TextField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.prop2TextField.returnKeyType = UIReturnKeyDone;
	self.prop2TextField.tag = 2;
	[self.prop2TextField setEnabled:false];
	[self.prop2TextField addTarget:self
							action:@selector(valueChanged:)
				  forControlEvents:UIControlEventEditingChanged];
	[self.view addSubview:self.prop2TextField];
	
	self.submitButtonY = prop2TfY + self.prop2TextField.frame.size.height + self.spacing;
}

- (void)viewWillAppear:(BOOL)animated
{
	self.xIndent = 10;
	self.spacing = 10;
	self.yIndent = 15;
	self.scrnW = self.view.frame.size.width;
	self.textWidth = self.scrnW;
	self.textHeight = 21;
	[self editTools];
	if([self.editType isEqualToString:@"editName"]) {
		[self editNameTools];
	} else if([self.editType isEqualToString:@"resetPassword"]) {
		[self resetPasswordTools];
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
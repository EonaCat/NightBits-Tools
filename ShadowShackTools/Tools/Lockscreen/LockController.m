#import "LockController.h"
#import <QuartzCore/QuartzCore.h>

//
//  LockController.m
//  Created by NightBits
//  Copyright 2013 NightBits. All rights reserved.
//

//private methods
@interface LockController()

- (void)setupSubviews;
- (void)setupNavigationBar;
- (void)setupTextFields;
- (void)resetFields;
- (void)passcodeDidNotMatch:(NSString*)incorrectPassword;
- (void)dissmissView;

@property (nonatomic, strong) NSMutableString *tempString;
@property (nonatomic, strong) UITextField *hiddenField;
@property (nonatomic, strong) UINavigationItem *navigationItem;

@end

@implementation LockController

@synthesize delegate;
@synthesize style;
@synthesize passcode;
@synthesize prompt;
@synthesize subPrompt;
@synthesize hint;
@synthesize hiddenField;
@synthesize navigationItem;
@synthesize tempString;
@synthesize title;
@synthesize hideCode;
@synthesize waitingAlert;

- (id)initWithTitle:(NSString*)newTitle prompt:(NSString*)newPrompt errorMessage:(NSString*)newSubPrompt correctMessage:(NSString*)newCorrectMessage passCode:(NSString*)newPasscode hint:(NSString*)newHint color:(UIColor*)newColor color2:(UIColor*)newColor2 fieldAmount:(NSInteger)newFieldAmount style:(STYLE)newStyle delegate:(id)newDelegate tag:(NSInteger)newTag cancelButton:(BOOL)cancelButton
{
	if (self = [super init])
    {
        _iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        
        if (_iPad)
        {
            _deviceWidth = 768;
        }
        else
        {
            _deviceWidth = 320;
        }
        
        newTitle == nil ? [NSString stringWithFormat:@"Security"] : newTitle;
        newPrompt == nil ? [NSString stringWithFormat:@"Insert pincode"] : newPrompt;
        newSubPrompt == nil ? [NSString stringWithFormat:@"Invalid code"] : newSubPrompt;
        newHint == nil ? [NSString stringWithFormat:@"As a security you need to supply a pincode"] : newHint;
        newColor == nil ? [UIColor whiteColor] : newColor;
        newColor2 == nil ? [UIColor whiteColor] : newColor2;
        //newFieldAmount == 0 ? 4 : newFieldAmount;
        newCorrectMessage == nil ? [NSString stringWithFormat:@"Code is valid"] : newCorrectMessage;
        newPasscode == nil ? [NSString stringWithFormat:@"0000"] : newCorrectMessage;
        
        self.cancel = cancelButton;
        self.tag = newTag;
        self.title = newTitle;
        self.prompt = newPrompt;
        self.subPrompt = newSubPrompt;
        self.hint = newHint;
        self.color = newColor;
        self.color2 = newColor2;
        self.correct = newCorrectMessage;
        self.passcode = newPasscode;
		self.style = newStyle;
        self.fieldsAmount = newFieldAmount;
        self.delegate = newDelegate;
        
		self.tempString = [NSMutableString string];
		self.hideCode = true;
        self.waitingAlert = false;
	}
	
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//needs a delegate
	assert (delegate != nil);
	
	//check if passcode is set for AUTHENTICATION
	if (style == AUTHENTICATE)
    {
		assert (passcode != nil);
	}
	
	[self setupSubviews];
	
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)setupSubviews
{
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    if (self.waitingAlert)
    {
        //Alert
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Status", @"LockController", @"Status")
                                           message:NSLocalizedStringFromTable(@"Please wait", @"LockController", @"Please wait")
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil, nil];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [alert addGestureRecognizer:singleTap];
    }
    
	//main prompt
    promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, _deviceWidth, 25)];
	promptLabel.textAlignment = NSTextAlignmentCenter;
	promptLabel.backgroundColor = [UIColor clearColor];
	promptLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.50];
	promptLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
    promptLabel.shadowOffset = CGSizeMake(0, -0.75);
	promptLabel.textColor = [UIColor blackColor];
    promptLabel.text = prompt;
	[self.view addSubview:promptLabel];
    
    //subPrompt
    subPromptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, _deviceWidth, 25)];
	subPromptLabel.textAlignment = NSTextAlignmentCenter;
	subPromptLabel.backgroundColor = [UIColor clearColor];
	subPromptLabel.textColor = [UIColor redColor];
	subPromptLabel.font = [UIFont systemFontOfSize:14];
    subPromptLabel.text = subPrompt;
    subPromptLabel.hidden = true;
	[self.view addSubview:subPromptLabel];
    
    // hint
	hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 160, _deviceWidth, 100)];
	hintLabel.textAlignment = NSTextAlignmentCenter;
	hintLabel.backgroundColor = [UIColor clearColor];
	hintLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.50];
	hintLabel.font = [UIFont systemFontOfSize:14];
    hintLabel.shadowOffset = CGSizeMake(0, -0.75);
    hintLabel.numberOfLines = 2;
	hintLabel.textColor = [UIColor blackColor];
    hintLabel.text = hint;
	[self.view addSubview:hintLabel];
    
	//bar
	[self setupNavigationBar];
    
	//text fields
	[self setupTextFields];
}

- (void)setupNavigationBar
{
    UINavigationBar *navBar;
    
    navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0,0,_deviceWidth,50)];
    navBar.barStyle = UIBarStyleBlack;
	[self.view addSubview:navBar];
	navigationItem = [[UINavigationItem alloc]init];
    
    if (self.cancel)
    {
        [navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:self
                                                                                           action:@selector(userDidCancel:)]
                                     animated:NO];
    }
	
	[navBar pushNavigationItem:navigationItem animated:NO];
	
	navigationItem.title = title;
    
    if (self.color)
    {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.view.bounds;
        gradient.colors = @[(id)[self.color CGColor], (id)[self.color2 CGColor],(id)[self.color CGColor], (id)[self.color CGColor]];
        [self.view.layer insertSublayer:gradient atIndex:0];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
        {
            [navBar setTintColor:self.color];
        }
        else
        {
            [navBar setBarTintColor:self.color];
        }
    }
}

- (void)setupTextFields
{
	int toppadding;
	int leftpadding;
	int width;
	int height;
	int padding;
    CGFloat fontsize;
    
    
    if (_iPad)
    {
        if (_fieldsAmount == 4)
        {
            leftpadding = 150;
        }
        else
        {
            leftpadding = 130;
        }
        
        width = 100;
        height = 100;
        toppadding = 250;
        padding = 60;
        fontsize = 64;
    }
    else
    {
        if (_fieldsAmount == 4)
        {
            leftpadding = 40;
        }
        else
        {
            leftpadding = 20;
        }
        width = 50;
        height = 50;
        toppadding = 125;
        padding = 30;
        fontsize = 32;
    }
    
    // Initialise the textField array
    textFieldArray = [NSMutableArray array];
    
    for (int i = 0; i < self.fieldsAmount; i++)
    {
        UITextField *textField;
        
        textField = [[UITextField alloc]initWithFrame:CGRectMake(leftpadding + width*i + padding,toppadding,width,height)];
        
        textField.backgroundColor = [UIColor whiteColor];
        textField.borderStyle = UITextBorderStyleBezel;
        textField.secureTextEntry = self.hideCode;
        textField.font = [UIFont systemFontOfSize:fontsize];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.tag = i;
        textField.enabled = false;
        
        [self.view addSubview:textField];
        [textFieldArray addObject:textField];
    }
    
	hiddenField = [[UITextField alloc]initWithFrame:CGRectMake(0,0,500,500)];
	hiddenField.text = @"";
	hiddenField.keyboardType = UIKeyboardTypeNumberPad;
    hiddenField.keyboardAppearance = UIKeyboardAppearanceAlert;
	hiddenField.delegate = self;
    hiddenField.hidden = true;
	[hiddenField becomeFirstResponder];
    [self.view setBackgroundColor:[UIColor whiteColor]];
	[self.view addSubview:hiddenField];
}

-(BOOL)checkDecimal:(NSString *)string
{
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
    BOOL isDecimal = [numberFormat numberFromString:string] != nil;
    
    if (!isDecimal)
    {
        UIAlertView * decimalAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Decimal title", @"LockController", @"Decimal title")
                                                                message:NSLocalizedStringFromTable(@"Decimal message", @"LockController", @"Decimal message")
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
        [decimalAlert show];
    }
    return isDecimal;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    @try
    {
        if ([string isEqualToString:@""] || [self checkDecimal:string])
        {
            UITextField *currentTextField;
            
            // Check if the backSpace was pressed
            if ([string isEqualToString:@""])
            {
                [self.tempString setString:[self.tempString substringToIndex:[self.tempString length]-1]];
                currentTextField = textFieldArray[[self.tempString length]];
            }
            else
            {
                [self.tempString appendString:string];
                currentTextField = textFieldArray[[self.tempString length] -1];
            }
            
            currentTextField.text = string;
            
            // we have reached the maximum characters
            if ([self.tempString length] == [textFieldArray count])
            {
                if (self.style == SET)
                {
                    if (passcode == nil)
                    {
                        //empty tempstring to passcode string
                        passcode = [self.tempString copy];
                        
                        self.tempString = [NSMutableString string];
                        
                        //reset fields
                        [self resetFields];
                        textField.text = @"";
                    }
                    else
                    {
                        //check if confirm matches first
                        givenPasscode = [self.tempString copy];
                        if ([passcode isEqualToString:self.tempString])
                        {
                            subPromptLabel.textColor = [UIColor greenColor];
                            subPromptLabel.text = self.correct;
                            [delegate lockControllerDidFinish:givenPasscode tag:self.tag];
                            [self dissmissView];
                        }
                        else
                        {
                            [self passcodeDidNotMatch:givenPasscode];
                        }
                    }
                }
                else if(self.style == AUTHENTICATE)
                {
                    givenPasscode = [self.tempString copy];
                    if ([passcode isEqualToString:self.tempString])
                    {
                        subPromptLabel.textColor = [UIColor greenColor];
                        subPromptLabel.text = self.correct;
                        [delegate lockControllerDidFinish:givenPasscode tag:self.tag];
                        [self dissmissView];
                    }
                    else
                    {
                        [self passcodeDidNotMatch:givenPasscode];
                    }
                    return false;
                }
            }
            return true;
        }
        return false;
    }
    @catch (NSException *exception)
    {
        // Do nothing
    }
}

- (void)passcodeDidNotMatch:(NSString*)incorrectPassword
{
    if (self.waitingAlert)
    {
        [alert show];
    }
    
	self.tempString = [NSMutableString string];
    
    subPromptLabel.textColor = [UIColor redColor];
    subPromptLabel.text = self.subPrompt;
	subPromptLabel.hidden = false;
    
	[self resetFields];
    [delegate lockControllerIncorrectPassword:incorrectPassword tag:self.tag];
}

- (void)resetFields
{
    for (UITextField *textField in textFieldArray)
    {
        textField.text = @"";
    }
	hiddenField.text = @"";
}

- (void)incorrect
{
    if (self.waitingAlert)
    {
        [alert dismissWithClickedButtonIndex:0 animated:true];
    }
}


- (void)finished
{
    if (self.waitingAlert)
    {
        [alert dismissWithClickedButtonIndex:0 animated:true];
    }
    
    subPromptLabel.textColor = [UIColor greenColor];
    subPromptLabel.text = self.correct;
}

- (void)dissmissView
{
	[self dismissViewControllerAnimated:TRUE completion:nil];	
}

- (void)userDidCancel:(id)sender
{
	[delegate lockControllerDidCancel:self.tag];
	[self dissmissView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

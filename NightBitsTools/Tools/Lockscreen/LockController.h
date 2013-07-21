#import <UIKit/UIKit.h>

//
//  LockController.h
//  Created by NightBits
//  Copyright 2013 NightBits. All rights reserved.
//

typedef enum
{
    AUTHENTICATE,
    SET
} STYLE;

@protocol LockControllerDelegate

@required
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
- (void)lockControllerDidFinish:(NSString*)passcode tag:(NSInteger)tag;
- (void)lockControllerIncorrectPassword:(NSString*)incorrectPassword tag:(NSInteger)tag;
- (void)lockControllerDidCancel:(NSInteger)tag;

@end


@interface LockController : UIViewController <UITextFieldDelegate>
{
	//Public
	STYLE style;
	NSString *passcode;
    NSString *givenPasscode;
    NSString *title;
	UILabel *promptLabel;
	UILabel *subPromptLabel;
	UILabel *hintLabel;
    UIAlertView *alert;
    int     _deviceWidth;
    
	id <LockControllerDelegate> __weak delegate;
	BOOL hideCode;
	
	//Private
    BOOL _iPad;
	BOOL retry;
	NSMutableString *tempString;
    
	UITextField *hiddenField;
	UINavigationItem *navigationItem;
    NSMutableArray *textFieldArray;
}

@property (nonatomic, weak) id delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) STYLE style;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *color2;
@property (nonatomic, strong) NSString *passcode;
@property (nonatomic, strong) NSString *prompt;
@property (nonatomic, strong) NSString *subPrompt;
@property (nonatomic, strong) NSString *hint;
@property (nonatomic, strong) NSString *correct;
@property (nonatomic) NSInteger tag;
@property (nonatomic) BOOL cancel;
@property (nonatomic) NSInteger fieldsAmount;
@property (nonatomic) BOOL hideCode;
@property (nonatomic) BOOL waitingAlert;

- (id)initWithTitle:(NSString*)newTitle prompt:(NSString*)newPrompt errorMessage:(NSString*)newSubPrompt correctMessage:(NSString*)newCorrectMessage passCode:(NSString*)newPasscode hint:(NSString*)newHint color:(UIColor*)newColor color2:(UIColor*)newColor2 fieldAmount:(NSInteger)newFieldAmount style:(STYLE)newStyle delegate:(id)newDelegate tag:(NSInteger)newTag cancelButton:(BOOL)cancelButton;

- (void)incorrect;
- (void)finished;

@end

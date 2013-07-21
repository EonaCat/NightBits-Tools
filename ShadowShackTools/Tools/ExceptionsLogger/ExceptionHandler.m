//
//  ExceptionHandler.m
//  Created by NightBits
//  Copyright 2013 NightBits. All rights reserved.
//

// The ExceptionHandler needs to be imported in the ApplicationDelegate by using the #import "ExceptionHandler.h"; statement in de .m file
// The following functions need to be created in the ApplicationDelegate.m file

// - (void)setExceptionHandler
// {
//      createExceptionHandler(@"YOUREMAILADDRESS", @"");
// }

// In the ApplicationDelegate file the method 
//  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
// need to be created inside this method you will need to implement the following code:   
//

//  //Create the exceptionHandler
//  [self performSelector:@selector(setExceptionHandler) withObject:nil afterDelay:0];
//
//
// You will need to implement the application delegate of the application before you can use the Email function.
// So be sure to import the applications's delegate headerfile and change the following line:
// (Located in the - (void) displayComposerSheet:(NSString *)body method)
//
// [self presentViewController: tempMailCompose animated:YES completion:nil];
//
// into
//
// [root.navigationController presentViewController: tempMailCompose animated:YES completion:nil];
//
// Be sure that the following line is present in your core or appdelegate file
// #define Delegate ((yourAppDelegateFileName*)[UIApplication sharedApplication].delegate)



#import "ExceptionHandler.h"
#import "DeviceIdentifier.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "ExceptionLogger.h"

const NSString *ExceptionName = @"ExceptionName";
const NSString *ExceptionKey = @"ExceptionKey";
const NSString *ExceptionAddresses = @"ExceptionAddresses";

NSString    *ExceptionTitle = @"iPhone Exception";
NSString    *ExceptionEmail = @"";
NSString    *ExceptionBCCEmail = @"";
NSString    *ExceptionMessage = @"";
NSInteger   ExceptionShown = 0;
BOOL        ExceptionAlert = true;

volatile int32_t    ExceptionCount = 0;
const int32_t       ExceptionMaximum = 5;

const NSInteger     ExceptionHandlerSkipAddressCount = 4;
const NSInteger     ExceptionHandlerReportAddressCount = 5;

@implementation ExceptionHandler

+ (NSArray *)backtrace
{
    void    *callstack[128];
    int     frames = backtrace(callstack, 128);
    char    **stringSymbols = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray  *backtrace = [NSMutableArray arrayWithCapacity:frames];
    
    for (i = ExceptionHandlerSkipAddressCount; i < ExceptionHandlerSkipAddressCount + ExceptionHandlerReportAddressCount; i++)
    {
	 	[backtrace addObject:[NSString stringWithUTF8String:stringSymbols[i]]];
    }
    free(stringSymbols);
    
    return backtrace;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)Index
{
	if (Index == 0) // Quit button clicked
	{   
        ExceptionShown = 0;
		dismissed = YES;
	} 
    else if (Index == 1)  // Continue button clicked
    {
        ExceptionShown = 0;
    } 
    else if (Index == 2)     // Email button clicked        
    {
        // Create the email that needs to be send
        [self performSelector:@selector(showComposer:) withObject:ExceptionMessage afterDelay:0.1];
    }
}


// Displays an email composition interface inside the application. Populates all the Mail fields. 
- (void) displayComposerSheet:(NSString *)body 
{	
	MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
	mailController.mailComposeDelegate = self;

    NSArray *toRecipient = [[NSArray alloc] initWithObjects:ExceptionEmail,nil];
    [mailController setToRecipients:toRecipient];
    
    if (ExceptionBCCEmail.length > 0)
    {
        NSArray *bccRecipient = [[NSArray alloc] initWithObjects:ExceptionBCCEmail,nil];
        [mailController setBccRecipients:bccRecipient];
    }
    [mailController setSubject:ExceptionTitle];
	[mailController setMessageBody:body isHTML:NO];
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:mailController.view];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Result: canceled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Result: saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Result: sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Result: failed");
			break;
		default:
			NSLog(@"Result: not sent");
			break;
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

// Launches the Mail application on the device. Workaround
-(void)launchMailAppOnDevice:(NSString *)body
{
	NSString *recipients;
    
    if ([ExceptionEmail isEqualToString:@"YOUREMAILADDRESS"])
    {
        NSLog(@"Could not send email (default values where detected!)");
        return;
    }
    
    if (ExceptionBCCEmail.length > 0)
    {
        recipients = [NSString stringWithFormat:@"mailto:%@?bcc=%@?subject=%@", ExceptionEmail, ExceptionBCCEmail, ExceptionTitle];
    }
    else
    {
        recipients = [NSString stringWithFormat:@"mailto:%@?subject=%@", ExceptionEmail, ExceptionTitle];
    }
    
	NSString *mailBody = [NSString stringWithFormat:@"&body=%@", body];
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, mailBody];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

// Call this method and pass parameters
-(void) showComposer:(id)sender
{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));

	if (mailClass != nil)
    {
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
        {
			[self displayComposerSheet:sender];
		}
        else
        {
			[self launchMailAppOnDevice:sender];
		}
	}
    else
    {
		[self launchMailAppOnDevice:sender];
	}
}


- (void)saveAndQuit
{
	
}

- (void)checkForExceptions:(NSException *)exception
{
    if (ExceptionShown == 0)
    {
        ExceptionShown = 1;
        [self saveAndQuit];

        /*
        // Set the IMEI Number
        // Check if you got iOS5
        NSString *IMEI;
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 5.0)
        {   
            IMEI = [[NSString alloc] initWithString:[[UIDevice currentDevice] deviceIdentifier]];
        } 
        else
        {
            IMEI = [[NSString alloc] initWithString:[[UIDevice currentDevice] uniqueIdentifier]];  
        }        
         */
        
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd hh-mm"];
        NSString *resultString = [dateFormatter stringFromDate: currentTime];
        
        ExceptionMessage = [NSString  stringWithFormat:
                            @"iPhone exception information:\n\n"
                            @"Date: %@\n"                
                            @"Application Name: %@\n"
                            @"Localized Application Name: %@\n"
                            @"Devicetype: %@\n"
                            @"============================= \n"                    
                            @"Reason: %@\n"
                            @"============================= \n\n"                    
                            @"***************************** \n\n"                                        
                            @"Exception: %@\n\n"
                            @"***************************** \n",
                            resultString, [[[NSBundle mainBundle] infoDictionary]   objectForKey:@"CFBundleName"],
                            [[[NSBundle mainBundle] infoDictionary]   objectForKey:@"CFBundleDisplayName"], [UIDevice currentDevice].model,
                            [exception reason],[[exception userInfo] objectForKey:ExceptionAddresses]];
        
        if (ExceptionAlert)
        {
            UIAlertView *alert =
            [[UIAlertView alloc]
              initWithTitle:@"You have found an error"
              message:[NSString stringWithFormat:                  @"You can try continuing using the application "
                       @"but it may become unstable after a while.\n"
                       @"Please send us an email with the error report " 
                       @"by clicking on the send report button."]
              delegate:self
              cancelButtonTitle:@"Quit"
              otherButtonTitles:@"Continue", @"Send report",nil];
            [alert show];
        }
        else 
        {
            [[ExceptionLogger instance] log:ExceptionMessage];         
        }
        
        CFRunLoopRef runLoop = CFRunLoopGetCurrent();
        CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
        
        while (!dismissed)
        {
            for (NSString *mode in (__bridge NSArray *)allModes)
            {
                CFRunLoopRunInMode((__bridge CFStringRef)mode, 0.001, false);
            }
        }
        
        CFRelease(allModes);
        
        NSSetUncaughtExceptionHandler(NULL);
        signal(SIGABRT, SIG_DFL);
        signal(SIGILL, SIG_DFL);
        signal(SIGSEGV, SIG_DFL);
        signal(SIGFPE, SIG_DFL);
        signal(SIGBUS, SIG_DFL);
        signal(SIGPIPE, SIG_DFL);
        
        if ([[exception name] isEqual:ExceptionName])
        {
            kill(getpid(), [[[exception userInfo] objectForKey:ExceptionKey] intValue]);
        }
        else
        {
            [exception raise];
        }
    }
}

@end

void checkForExceptions(NSException *exception)
{
	int32_t exceptionCount = OSAtomicIncrement32(&ExceptionCount);
	if (exceptionCount > ExceptionMaximum)
	{
        NSLog(@"Maximum amount of exceptions where raised !");
		return;
	}
	
	NSArray *callStack = [ExceptionHandler backtrace];
	NSMutableDictionary *userInfo =
    [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
	[userInfo
     setObject:callStack
     forKey:ExceptionAddresses];
	
	[[[ExceptionHandler alloc] init]
     performSelectorOnMainThread:@selector(checkForExceptions:)
     withObject:
     [NSException
      exceptionWithName:[exception name]
      reason:[exception reason]
      userInfo:userInfo]
     waitUntilDone:YES];
}

void ExceptionCounter(int exception)
{
	int32_t exceptionCount = OSAtomicIncrement32(&ExceptionCount);
	
    if (exceptionCount > ExceptionMaximum)
	{
		return;
	}
	
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:exception] forKey:ExceptionKey];
    
	NSArray *callStack = [ExceptionHandler backtrace];
	[userInfo setObject:callStack forKey:ExceptionAddresses];
	
	[[[ExceptionHandler alloc] init] performSelectorOnMainThread:@selector(checkForExceptions:)
     withObject: [NSException exceptionWithName:[NSString stringWithFormat:@"%@",ExceptionTitle]
     reason:  [NSString stringWithFormat: NSLocalizedString(@"Signal %d was raised.", nil), signal]
      userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:exception] forKey:ExceptionKey]]
     waitUntilDone:YES];
}

void createExceptionHandler(NSString *emailAddress,NSString *BCCemailAddress)
{
	NSSetUncaughtExceptionHandler(&checkForExceptions);
	signal(SIGABRT, ExceptionCounter);
	signal(SIGILL, ExceptionCounter);
	signal(SIGSEGV, ExceptionCounter);
	signal(SIGFPE, ExceptionCounter);
	signal(SIGBUS, ExceptionCounter);
	signal(SIGPIPE, ExceptionCounter);
    
    ExceptionEmail  = emailAddress;
    ExceptionBCCEmail = BCCemailAddress;
}
//
//  ExceptionHandler.h
//  Created by NightBits
//  Copyright 2013 NightBits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>

#define exceptionDelegate [[UIApplication sharedApplication] delegate] 

@interface ExceptionHandler :  UIViewController <MFMailComposeViewControllerDelegate>
{
	BOOL dismissed;
}

@end

void createExceptionHandler(NSString *emailAddress,NSString *BCCemailAddress);
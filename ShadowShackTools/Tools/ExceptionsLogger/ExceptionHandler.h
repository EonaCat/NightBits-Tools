//
//  ExceptionHandler.h
//  Created by ShadowShack
//  Copyright 2013 ShadowShack. All rights reserved.
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
//
//  Popup.h
//  Created by ShadowShack
//  Copyright 2013 ShadowShack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Popup : NSObject
{
    NSTimer *_notificationTimer;
    UILabel *_target;
    UIColor *_targetOldBackgroundColor;
    UIColor *_targetOldTextColor;
    NSString *_targetText;
    UIAlertView *_alert;
}

-(void)showAlert:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonText:(NSString*)cancelButtonText otherButtonText:(NSString*)otherButtonText tag:(NSInteger)tag;
-(void)showDebugNotification:(NSString*)message textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor target:(UILabel*)target;
-(void)dismiss;

+ (id)getInstance;

@end

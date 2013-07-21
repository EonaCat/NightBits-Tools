//
//  Popup.m
//  Created by NightBits
//  Copyright 2013 NightBits. All rights reserved.
//

#import "Popup.h"

@implementation Popup

static Popup *_instance;

+ (id)getInstance
{
    @synchronized(self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

-(void)showAlert:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonText:(NSString *)cancelButtonText otherButtonText:(NSString *)otherButtonText tag:(NSInteger)tag
{
    _alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:[cancelButtonText length] == 0 ? nil : cancelButtonText
                                          otherButtonTitles:[otherButtonText length] == 0 ? nil : otherButtonText,nil];
    _alert.tag = tag;
    [_alert show];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_alert addGestureRecognizer:singleTap];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)dismiss
{
    [_alert dismissWithClickedButtonIndex:0 animated:true];
}

-(void)showDebugNotification:(NSString *)message textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor target:(UILabel *)target
{
    _target = target;
    _targetOldBackgroundColor = target.backgroundColor;
    _targetOldTextColor = target.textColor;
    _targetText = target.text;

    
    target.textColor = textColor;
    target.backgroundColor = backgroundColor;
    target.text = message;
    _notificationTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(debugNotificationTimeElapsed:) userInfo:nil repeats:NO];
}

- (void)debugNotificationTimeElapsed:(NSTimer*)timer
{
    @try
    {
        UILabel *target =  _target;
        target.backgroundColor = _targetOldBackgroundColor;
        target.textColor = _targetOldTextColor;
        target.text = _targetText;

        
        [_notificationTimer invalidate];
    }
    @catch (NSException *exception)
    {
        NSLog(@"DebugNotificationError: %@",exception.description);
    }
}


@end

//
//  AppDelegate.h
//  Created by NightBits
//  Copyright 2013 NightBits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

#define Delegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL iPad;

@end

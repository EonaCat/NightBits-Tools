//
//  AppDelegate.h
//  Created by ShadowShack
//  Copyright 2013 ShadowShack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

#define Delegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL iPad;

@end

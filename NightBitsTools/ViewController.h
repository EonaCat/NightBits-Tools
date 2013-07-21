//
//  ViewController.h
//  Created by NightBits
//  Copyright 2013 NightBits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockController.h"

@interface ViewController : UIViewController <LockControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *showExceptionsButton;
@property (weak, nonatomic) IBOutlet UIButton *throwException;
@property (weak, nonatomic) IBOutlet UIButton *showToastButton;
@property (weak, nonatomic) IBOutlet UIButton *showPopupButton;
@property (weak, nonatomic) IBOutlet UIButton *showLockScreenButton;

@end

//
//  ViewController.m
//  Created by NightBits
//  Copyright 2013 NightBits. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Toast.h"
#import "Popup.h"
#import "LockController.h"
#import "ExceptionLogger.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showExceptionsAction:(UIButton *)sender
{
    // Show ExceptionLogger (Check for iPhone or iPad)
    ExceptionLogger* exceptionLogger;
    
    if (Delegate.iPad)
    {
        exceptionLogger = [[ExceptionLogger alloc] initWithNibName:@"ExceptionLogger-iPad" bundle:nil];
    }
    else
    {
        exceptionLogger = [[ExceptionLogger alloc] initWithNibName:@"ExceptionLogger" bundle:nil];
    }
    exceptionLogger.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:exceptionLogger animated:YES completion:nil];
}

- (void)lockControllerIncorrectPassword:(NSString*)incorrectPassword tag:(NSInteger)tag
{
    [[Popup getInstance] showAlert:@"Incorrect" message:@"All your base are belong to us" delegate:self cancelButtonText:@"OK" otherButtonText:nil tag:0];

}

-(void)lockControllerDidFinish:(NSString *)passcode tag:(NSInteger)tag
{
    [[Popup getInstance] showAlert:@"Correct!" message:@"All your base belongs to you" delegate:self cancelButtonText:@"OK" otherButtonText:nil tag:0];
}

- (IBAction)throwExceptionAction:(UIButton *)sender
{
         @throw [[NSException alloc] initWithName:@"NSException thrown!" reason:@"Testing" userInfo:nil];
}

- (IBAction)showToastAction:(UIButton *)sender
{
    //[self.view makeToast:[NSString stringWithFormat:@"Toasted!"] duration:3.0 position:@"top"];
    [self.view makeToast:@"NightBits Toast!" duration:3.0 position:@"top" title:@"Toasted!" image:[UIImage imageNamed:@"toast.png"]];
}

- (IBAction)showPopupAction:(UIButton *)sender
{
    [[Popup getInstance] showAlert:@"Popup!" message:@"NightBits Popup" delegate:self cancelButtonText:@"OK" otherButtonText:nil tag:0];
}

- (IBAction)showLockScreenAction:(UIButton *)sender
{
    LockController *lockController = [[LockController alloc] init];
    
    [lockController setDelegate:self];
    [lockController setTitle:@"NightBits LOCK!"];
    [lockController setSubPrompt:@"Passcode => 0000"];
    [lockController setPasscode:@"0000"];
    
   // [self presentViewController:lockController animated:true completion:nil];
    [[Popup getInstance] showAlert:@"Lock!" message:@"Doesn't work on iOS7 yet!" delegate:self cancelButtonText:@"OK" otherButtonText:nil tag:0];
}

@end

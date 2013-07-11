//
//  ViewController.m
//  Created by ShadowShack
//  Copyright 2013 ShadowShack. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Toast.h"
#import "Popup.h"
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

- (IBAction)throwExceptionAction:(UIButton *)sender
{
         @throw [[NSException alloc] initWithName:@"NSException thrown!" reason:@"Testing" userInfo:nil];
}

- (IBAction)showToastAction:(UIButton *)sender
{
    //[self.view makeToast:[NSString stringWithFormat:@"Toasted!"] duration:3.0 position:@"top"];
    [self.view makeToast:@"ShadowShack Toast!" duration:3.0 position:@"top" title:@"Toasted!" image:[UIImage imageNamed:@"toast.png"]];
}

- (IBAction)showPopupAction:(UIButton *)sender
{
    [[Popup getInstance] showAlert:@"Popup!" message:@"ShadowShack Popup" delegate:self cancelButtonText:@"OK" otherButtonText:nil tag:0];
}

@end

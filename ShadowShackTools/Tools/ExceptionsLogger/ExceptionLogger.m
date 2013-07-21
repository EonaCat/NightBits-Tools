//
//  ExceptionLogger.m
//  Created by NightBits
//  Copyright 2013 NightBits. All rights reserved.
//

// The ExceptionLogger needs to be imported in a view by using the #import "ExceptionLogger.h"; statement in de .m file
// The following functions need to be created in the view.m file

// - (void)swipedScreen:(UISwipeGestureRecognizer*)swipeGesture 
// {
// // Show ExceptionLogger (Check for iPhone or iPad)
// ExceptionLogger* exceptionLogger = nil;
// if (iPad)
// {
//     exceptionLogger = [[ExceptionLogger alloc] initWithNibName:@"ExceptionLogger-iPad" bundle:nil];
// }
// else
// {
//     exceptionLogger = [[ExceptionLogger alloc] initWithNibName:@"ExceptionLogger" bundle:nil];
// }
// [self.navigationController pushViewController:exceptionLogger animated:YES completion:nil];
// [exceptionLogger release];     
// }

// Add these line to your ViewDidLoad method:
//
// // Add the ExceptionLogger Swipe Gesture
// UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(swipedScreen:)];
// swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
// [self.view addGestureRecognizer:swipeRight];

// In your delegate file you need to write the following lines:
//
//
//

// Be sure that the following line is present in your core or delegate file
// #define Delegate ((yourAppDelegateFileName*)[UIApplication sharedApplication].delegate)

#import "ExceptionLogger.h"

@implementation ExceptionLogger
static ExceptionLogger* _instance = nil;

@synthesize textView;
@synthesize navigationBar;

+(ExceptionLogger*)instance
{
	@synchronized([ExceptionLogger class])
	{
		if (!_instance)
        {
			[self alloc];
        }
		return _instance;
	}
	return nil;
}

+(id)alloc
{
	@synchronized([ExceptionLogger class])
	{
		_instance = [super alloc];
		return _instance;
	}
	return nil;
}

- (void)viewDidLoad 
{
    @try
    {
        [super viewDidLoad];
        self.navigationBar.title = NSLocalizedStringFromTable(@"Exceptions", @"ExceptionsLogger", @"Exceptions");
        navigationBar.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedStringFromTable(@"Back", @"ExceptionsLogger", @"Back")
                                                                            style: UIBarButtonItemStyleBordered
                                                                           target: self
                                                                           action: @selector(Back:)];
        
        navigationBar.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle: NSLocalizedStringFromTable(@"Clear", @"ExceptionsLogger", @"Clear")
style: UIBarButtonItemStyleBordered
                                                                                   target: self
                                                                                   action: @selector(Clear:)];
        textView.editable = false;
        textView.text = @"";
        [self updateLog:self];
        textView.hidden = false;
                
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateLog:) userInfo:nil repeats:YES];
    }  
    @catch(NSException* exception) 
    {
        NSLog(@"Exception: ExceptionLogger > viewDidLoad\n%@",exception);
    }
}

- (IBAction)Back:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)log:(NSString*)exception
{
    @try
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-YYYY HH:mm:ss"];
        NSString *stringFromDate = [dateFormatter stringFromDate:[NSDate date]];
        NSString* stringData = [[NSString alloc] initWithFormat:@"\n%@\n\n %@", stringFromDate, exception];
        NSData *dataToWrite = [stringData dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [docsDirectory stringByAppendingPathComponent:@"Exceptions.log"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];

        if (![fileManager fileExistsAtPath:path])
        {
            [fileManager createFileAtPath:path contents:nil attributes:nil];
        }
        
        NSDictionary* attributes = [fileManager attributesOfItemAtPath:path error:nil];
        NSNumber* fileSize = [attributes objectForKey:NSFileSize];
        // Check if the logfile exceeds 10 MB

        if ([fileSize intValue] > 10 * 1024)
        {
            [fileManager removeItemAtPath:path error:nil];
            [fileManager createFileAtPath:path contents:nil attributes:nil];
        }
        
        NSMutableData *concatenatedData = [[NSMutableData alloc] init];            
        [concatenatedData appendData: dataToWrite];                
        NSData *fileData = [[NSData alloc] initWithContentsOfFile:(NSString *)path];            
        [concatenatedData appendData: fileData];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];        
        [fileHandle seekToFileOffset:0];
        [fileHandle writeData:concatenatedData];
    }
    @catch(NSException* exception) 
    {
        NSLog(@"Exception: ExceptionLogger > log\n%@",exception);
    } 
}

- (BOOL)canBecomeFirstResponder 
{
    return NO;
}

-(IBAction)updateLog:(id)sender
{
    @try
    {
        NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [docsDirectory stringByAppendingPathComponent:@"Exceptions.log"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path])
        {
            textView.text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        }
    }
    @catch(NSException* exception) 
    {
        NSLog(@"Exception: ExceptionLogger > updateLog\n%@",exception);
    }
}

-(IBAction)Clear:(id)sender
{
    @try
    {
        NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        path = [docsDirectory stringByAppendingPathComponent:@"Exceptions.log"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path])
        {
            [fileManager removeItemAtPath:path error:nil];
            [fileManager createFileAtPath:path contents:nil attributes:nil ];
        }
        
            [self updateLog:self];
    }  
    @catch(NSException* exception) 
    {
        NSLog(@"Exception: ExceptionLogger > Clear\n%@",exception);
    }
}

- (void)viewWillAppear:(BOOL)animated 
{
    @try
    {
        [super viewWillAppear:animated];
    }
    @catch(NSException* exception) 
    {
        NSLog(@"Exception: ExceptionLogger > viewWillAppear\n%@",exception);
    }
}


- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
}

// Rotate application view
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}


@end
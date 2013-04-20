//
//  GBMAppDelegate.m
//  GBBrowserMobile
//
//  Created by Vladislav Korotnev on 2/3/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import "GBMAppDelegate.h"

#import "GBMViewController.h"

@implementation GBMAppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}
/*
- (void) handleCrashReport {
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSData *crashData;
    NSError *error;
    
    // Try loading the crash report
    crashData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
    if (crashData == nil) {
        NSLog(@"Could not load crash report: %@", error);
        goto finish;
    }
    
    // We could send the report from here, but we'll just print out
    // some debugging info instead
    report = crashData ;
    [report retain];
    if (report == nil) {
        NSLog(@"Could not parse crash report");
        goto finish;
    }
    [[[UIAlertView alloc]initWithTitle:@"Bummer!" message:@"It seems GBBrowser has crashed. Would you like to report this crash?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil]show];

    
    // Purge the report
finish:
    [crashReporter purgePendingCrashReport];
    return;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	
	[self.window.rootViewController dismissModalViewControllerAnimated:YES];
	
	NSString *mailError = nil;
	
	switch (result) {
		case MFMailComposeResultSent: ; break;
		case MFMailComposeResultFailed: mailError = @"Failed sending mail, please try again...";
			break;
		default:
			break;
	}
	
	if (mailError != nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error sending mail" message:[NSString stringWithFormat:@"%@ -- %@",mailError,error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Bummer!"]&&(alertView.cancelButtonIndex != buttonIndex)) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        [mailViewController setSubject:@"GBBrowser Crash Report"];
        mailViewController.mailComposeDelegate = self;
        NSString*developer= [[EncryptionModule new]decryptString:@"wmbelpspuofwAhnbjm/dpn" withOffset:1]; // i am paranoid lol
        [mailViewController setToRecipients:@[developer]];
        [mailViewController addAttachmentData:report mimeType:@"application/x-octet-stream" fileName:@"report.plreport"];
        [mailViewController setMessageBody:@"Please describe what did you do prior to crash:" isHTML:false];
        [[[UIAlertView alloc]initWithTitle:@"Important" message:@"Please describe what did you do prior to crash, DON'T send the mail as is!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        [self.window.rootViewController presentModalViewController:mailViewController animated:YES];
        [mailViewController release];
    }
}*/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[GBMViewController alloc] initWithNibName:@"GBMViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
  //  PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    //NSError *error;
    
    // Check if we previously crashed
   // if ([crashReporter hasPendingCrashReport])
    //    [self handleCrashReport];
    
    // Enable the Crash Reporter
   // if (![crashReporter enableCrashReporterAndReturnError: &error])
 //       NSLog(@"Warning: Could not enable crash reporter: %@", error);
    
    NSURL *urlToParse = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if (urlToParse) {
        [self application:application handleOpenURL:urlToParse];
    }
    return YES;
}
-(void)application:(UIApplication*)app handleOpenURL:(NSURL *)url {
    NSLog(@"Has to parse %@",url.absoluteString);
    if (![url.absoluteString hasPrefix:@"gbbsearch://?"]) {
        [[[UIAlertView alloc]initWithTitle:@"Invalid URL format" message:@"Use gbbsearch://?search_string instead." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
        return;
    }
    [self.viewController setInitialSearchString:[[[[url absoluteString]stringByReplacingOccurrencesOfString:@"gbbsearch://?" withString:@""]stringByReplacingOccurrencesOfString:@"%20" withString:@"_"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.viewController.initialSearchString retain];
    if (self.viewController.isReady) {
        [self.viewController _checkForPassedSearch];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

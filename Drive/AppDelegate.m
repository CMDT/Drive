//
//  AppDelegate.m
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//
//  Updating for ios 10.0.2 and new sound features implementation.
//

#import "AppDelegate.h"
#import "mySingleton.h"

@implementation AppDelegate
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    mySingleton *singleton = [mySingleton sharedSingleton];
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
        {
        //NSLog(@"ok");
        //continue to App run
        singleton.okGoNow=YES;
        }
    else
        {
        //NSLog(@"canceled the App");
        singleton.okGoNow=NO;
        //stop App if cancelled
        
        if (singleton.okGoNow == NO) {
            //NSLog(@"Cancelled");
            //the app has been cancelled by the alert cancel in the accept message in AppDelegate
            //STOP//
            UIApplication *app = [UIApplication sharedApplication];
            [app performSelector:@selector(suspend)];
            
            //wait 2 seconds while app is going background
            [NSThread sleepForTimeInterval:2.0];
            
            //exit app when app is in background
            exit(0);
            //stop
        } else {
            //NSLog(@"Running App.");
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Drive App Motor Control Test"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"I Agree"
                                              otherButtonTitles:@"I Do Not Agree", nil];

    UILabel *txtField = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 25.0, 400.0, 300.0)]; //x,y,width,height
    [txtField setFont:[UIFont fontWithName:@"Courier" size:(10.0)]];
    txtField.numberOfLines = 17;
    txtField.textColor = [UIColor darkGrayColor];
    txtField.text = @"To see details on how to use this\nApplication and adjust its settings,\nplease read the notes in the\n'Information' sections (i).\n\n* Safety Note *\nTake regular breaks and avoid strain.\nIf you develop discomfort using this App,\nyou must stop using it and seek advice.\n\nThis Application is NOT\nfor clinical use. v4.0.5,  10.Jan.2017\n";
    txtField.backgroundColor = [UIColor clearColor];
    txtField.tintColor = [UIColor redColor];
    txtField.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:txtField];
    [alertView setValue:txtField forKeyPath:@"accessoryView"]; //for ios 7 and above
    [alertView show];
    
    return YES;
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

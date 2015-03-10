//
//  AppDelegate.m
//  JYSTipCalculator
//
//  Created by John YS on 3/9/15.
//  Copyright (c) 2015 JohnYS. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *savedBillDate = [defaults objectForKey:@"savedDate"];
    if (savedBillDate) {
        NSTimeInterval timeElapsed = [[NSDate date] timeIntervalSinceDate:savedBillDate];
        if (timeElapsed > 300) {
            [defaults removeObjectForKey:@"savedBillAmount"];
            [defaults removeObjectForKey:@"savedDate"];
            [defaults synchronize];
        };
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    if ([self.lastBillAmount length] > 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.lastBillAmount forKey:@"savedBillAmount"];
        [defaults setObject:[NSDate date] forKey:@"savedDate"];
        [defaults synchronize];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

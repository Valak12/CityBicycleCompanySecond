//
//  AppDelegate.m
//  CityBicycleCompany
//
//  Created by Vala Kohnechi on 11/26/14.
//  Copyright (c) 2014 MVA. All rights reserved.
//

#import "AppDelegate.h"
#import "ProductViewController.h"
#import "Stripe.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end
NSString * const StripePublishableKey = @"pk_live_jdLUuUSwbsYw2exOCHsaxMbU";
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"srr6q0zfkpHLhFfGDIhEQIg4fNFtZ3DNigXlswBO" clientKey:@"MiUt4DiBSMZ6bgtWBuuPhAQwpUe0eEWRVmMyY5Os"];
    
    [Stripe setDefaultPublishableKey:StripePublishableKey];
    
    // Register for Push Notifications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                     UIUserNotificationTypeBadge |
                                                     UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    NSLog(@"didRegister for Push notifications");

    return YES;
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // The Installation object is where you store all the data needed to target push notifications.
    // Store the device token in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    
    //    currentInstallation.channels = @[ @"global"];
    [currentInstallation addUniqueObject:@"newSales" forKey:@"channels"];
    [currentInstallation addUniqueObject:@"newProducts" forKey:@"channels"];
    
//    NSArray *subscribedChannels = [PFInstallation currentInstallation].channels;
    

    [currentInstallation saveInBackground];
    
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}
// This method allows the notification to be received while the app is open (instead of in Notification Center)
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

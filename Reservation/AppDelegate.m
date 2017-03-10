//
//  AppDelegate.m
//  Reservation
//
//  Created by Hafiz Amaduddin Ayub on 3/7/17.
//  Copyright © 2017 GApp Studios. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  [[AppInfo sharedInfo] loadResources];
  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
  
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  
  [[AppInfo sharedInfo] saveResources];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  
  [[AppInfo sharedInfo] loadResources];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  
}


- (void)applicationWillTerminate:(UIApplication *)application {
  
}


@end

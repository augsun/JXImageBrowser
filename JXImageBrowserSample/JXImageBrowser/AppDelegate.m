//
//  AppDelegate.m
//  JXImageBrowser
//
//  Created by CoderSun on 4/2/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import "AppDelegate.h"
#import "JXMomentVC.h"
#import <UIImageView+WebCache.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[JXMomentVC alloc] init]];
    self.window.rootViewController = navi;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end










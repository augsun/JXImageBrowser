//
//  AppDelegate.m
//  JXImageBrowser
//
//  Created by shiba_iosJX on 4/24/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import "AppDelegate.h"
#import "JXMomentVC.h"
#import <UIImageView+WebCache.h>


@interface JXNavigationBar : UINavigationBar

@end

@implementation JXNavigationBar {
    CGSize _previousSize;
}

- (CGSize)sizeThatFits:(CGSize)size {
    size = [super sizeThatFits:size];
    if ([UIApplication sharedApplication].statusBarHidden) {
        size.height = 64;
    }
    return size;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGSizeEqualToSize(self.bounds.size, _previousSize)) {
        _previousSize = self.bounds.size;
        [self.layer removeAllAnimations];
        [self.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeAllAnimations];
        }];
    }
}

@end

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [[SDImageCache sharedImageCache] cleanDisk];

    
    UINavigationController *navi = [[UINavigationController alloc] initWithNavigationBarClass:[JXNavigationBar class]
                                                                                 toolbarClass:[UIToolbar class]];
    [navi addChildViewController:[[JXMomentVC alloc] init]];
    self.window.rootViewController = navi;

    
    
    return YES;
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

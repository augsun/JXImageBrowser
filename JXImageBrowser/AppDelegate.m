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

#warning Tip
// ====================================================================================================
/* 想不让导航栏向上偏移20 请加上以下代码解决 */
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
// ====================================================================================================

#warning Tip
/*
 * 如果全屏浏览图片不能隐藏状态栏 在 Info.plist 里加上 "View controller-based status bar appearance" 值为 NO
 */

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UINavigationController *navi = [[UINavigationController alloc] initWithNavigationBarClass:[JXNavigationBar class]
                                                                                 toolbarClass:[UIToolbar class]];
    [navi addChildViewController:[[JXMomentVC alloc] init]];
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










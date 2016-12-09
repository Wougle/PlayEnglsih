//
//  AppDelegate.m
//  PlayEnglish_iOS
//
//  Created by KentonYu on 16/9/20.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "IQKeyboardManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*********************** nav全局定义 ***************************/
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : TEXT_COLOR_SECONDARY};

    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    // hide title of back button
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    NSShadow *clearShadow = [[NSShadow alloc] init];
    clearShadow.shadowColor = [UIColor clearColor];
    clearShadow.shadowOffset = CGSizeMake(0, 0);
    
    UIColor *normalTitleColor = [UIColor blackColor];
    UIColor *highlightedTitleColor = [UIColor blackColor];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName : normalTitleColor,
                                                           NSShadowAttributeName : clearShadow
                                                           } forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName : highlightedTitleColor,
                                                           NSShadowAttributeName : clearShadow
                                                           } forState:UIControlStateHighlighted];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    
    [[UIToolbar appearance] setBarTintColor:[UIColor blackColor]];
    
    [self setNaviBack];
    
    /*********************** 初始化配置 ***************************/
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BaseTabBarController *vc = [BaseTabBarController new];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    
    //设置虚拟键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate
  // graphics rendering callbacks. Games should use this method to pause the
  // game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the active state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}

- (void)setNaviBack{
    
    UINavigationBar * navigationBar = [UINavigationBar appearance];
    
    //设置返回样式图片
    
    UIImage *image = [UIImage imageNamed:@"left_arrow_black"];
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    navigationBar.backIndicatorImage = image;
    
    navigationBar.backIndicatorTransitionMaskImage = image;
    
//    UIBarButtonItem *buttonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
//    
//    UIOffset offset;
//    
//    offset.horizontal = - 500;
//    
//    offset.vertical =  - 500;
//    
//    [buttonItem setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];
}

@end

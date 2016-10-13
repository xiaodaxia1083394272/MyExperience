//
//  AppDelegate.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/9/7.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>
#import "twoViewController.h"

#import "JokeViewController.h"
#import "NewsViewController.h"
#import "WeatherViewController.h"
#import "NoteViewController.h"



@interface AppDelegate ()                                                                                                                                                                              

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[RCIM sharedRCIM] initWithAppKey:@"uwd1c0sxdu5e1"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (storyboard) {
        self.window.rootViewController = [storyboard instantiateInitialViewController];
        [self.window makeKeyAndVisible];
        
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        tabBarController.tabBar.translucent = NO;
        tabBarController.delegate = self;
        
        //设置第一个Controller
        UINavigationController *firstNavigationController = (UINavigationController *)[tabBarController.viewControllers objectAtIndex:2];//这个viewControllers里装的是NavigationController而不是viewController吗？略神奇 其实我觉得应该是类似于实例化
        
        //游戏规则
        //做过才能理解
        JokeViewController *jvc = [[JokeViewController alloc] init];
        
        firstNavigationController.viewControllers = @[jvc];
        //tabBarController里的viewcontrollers装的是navigationController；
        //navigationController里的viewControllers装的是viewcontroller
        
        //设置第二个Controller
        UINavigationController *secondNavigationController = (UINavigationController *)[tabBarController.viewControllers objectAtIndex:0];
        
        NewsViewController *nvc = [[NewsViewController alloc] initWithStyle:@"新闻"];
        secondNavigationController.viewControllers = @[nvc];
        //设置第三个Controller
        UINavigationController *thirdNavigationController = (UINavigationController *)[tabBarController.viewControllers objectAtIndex:1];
        WeatherViewController *wvc = [[WeatherViewController alloc] init];
        thirdNavigationController.viewControllers = @[wvc];
        
        //设置第四个Controller
        UINavigationController *fourNavigationController = (UINavigationController *)[tabBarController.viewControllers objectAtIndex:3];
        NoteViewController *novc = [[NoteViewController alloc] init];
        
        fourNavigationController.viewControllers = @[novc];

        
    }
    
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

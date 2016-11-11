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
#import "MineViewController.h"




@interface AppDelegate ()                                                                                                                                                                              
@property (strong, nonatomic) UIView *launchView;
@end

@implementation AppDelegate

//在AppDelegate中增加，这个方法可以禁止横屏

//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
-(void)removeLun
{
    [self.launchView removeFromSuperview];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //注册微信
    [WXApi registerApp:@"wx4bf9f0896575b0e9"];
    
    // Override point for customization after application launch.
    [[RCIM sharedRCIM] initWithAppKey:@"uwd1c0sxdu5e1"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (storyboard) {
        self.window.rootViewController = [storyboard instantiateInitialViewController];
        [self.window makeKeyAndVisible];
//        self.launchView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
//        _launchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height);
//        [self.window addSubview:_launchView];
//        
//        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 300)];
////        NSString *str = @"http://www.jerehedu.com/images/temp/logo.gif";
////        [imageV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"default1.jpg"]];
//        imageV.image = [UIImage imageNamed:@"backLaunch.jpg"];
//        [_launchView addSubview:imageV];
//        
//        [self.window bringSubviewToFront:_launchView];
//        
//        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
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
        UINavigationController *secondNavigationController = (UINavigationController *)[tabBarController.viewControllers objectAtIndex:1];
        
        NewsViewController *nvc = [[NewsViewController alloc] initWithStyle:@"新闻" noteList:nil];
        secondNavigationController.viewControllers = @[nvc];
        //设置第三个Controller
        UINavigationController *thirdNavigationController = (UINavigationController *)[tabBarController.viewControllers objectAtIndex:0];
        WeatherViewController *wvc = [[WeatherViewController alloc] init];
        thirdNavigationController.viewControllers = @[wvc];
        
        //设置第四个Controller
        UINavigationController *fourNavigationController = (UINavigationController *)[tabBarController.viewControllers objectAtIndex:3];
        NoteViewController *novc = [[NoteViewController alloc] initWithHistoryObject:nil isShowHistoryObject:NO];
        
        fourNavigationController.viewControllers = @[novc];
        
        //设置第五个Controller
        UINavigationController *fiveNavigationController = (UINavigationController *)[tabBarController.viewControllers objectAtIndex:4];
        MineViewController *mvc = [[MineViewController alloc] init];
        
        fiveNavigationController.viewControllers = @[mvc];


        
    }
    
    return YES;
}

//跳转处理
//被废弃的方法. 但是在低版本中会用到.建议写上
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [WXApi handleOpenURL:url delegate:self];
}
//跳转处理
//被废弃的方法. 但是在低版本中会用到.建议写上
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    
    return [WXApi handleOpenURL:url delegate:self];
}
//跳转处理
//新的方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [WXApi handleOpenURL:url delegate:self];
}

//3.微信回调

- (void)onResp:(BaseResp *)resp

{
    
    /*
     
     WXSuccess           = 0,   成功
     
     WXErrCodeCommon     = -1,   普通错误类型
     
     WXErrCodeUserCancel = -2,   用户点击取消并返回
     
     WXErrCodeSentFail   = -3,    发送失败
     
     WXErrCodeAuthDeny   = -4,   授权失败
     
     WXErrCodeUnsupport  = -5,    微信不支持
     
     */
    
    NSString * strMsg = [NSString stringWithFormat:@"errorCode: %d",resp.errCode];
    
    NSLog(@"strMsg: %@",strMsg);
    
    NSString * errStr       = [NSString stringWithFormat:@"errStr: %@",resp.errStr];
    
    NSLog(@"errStr: %@",errStr);
    
    NSString * strTitle;
    
    //判断是微信消息的回调 --> 是支付回调回来的还是消息回调回来的.
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]])
        
    {
        
        // 判断errCode 进行回调处理
        
        if (resp.errCode == 0)
            
        {
            
            strTitle = [NSString stringWithFormat:@"分享成功"];
            
        }
        
    }
      
    //发出通知 从微信回调回来之后,发一个通知,让请求支付的页面接收消息,并且展示出来,或者进行一些自定义的展示或者跳转
    
    NSNotification * notification = [NSNotification notificationWithName:@"WXShare" object:resp.errStr];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
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

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

#import "MyENavigationController.h"

#import "JuHeService.h"
#import "IMUser.h"
#import "CommonDefine.h"






@interface AppDelegate ()<JuHeServiceDelegate>
@property (strong, nonatomic) UIView *launchView;
@property (strong, nonatomic) MyENavigationController *firstNavigationController;
@property (strong, nonatomic) MyENavigationController *secondNavigationController;
@property (strong, nonatomic) MyENavigationController *thirdNavigationController;
@property (strong, nonatomic) MyENavigationController *fourNavigationController;
@property (strong, nonatomic) MyENavigationController *fiveNavigationController;

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
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    //manager.requestSerializer = [AFPropertyListRequestSerializer serializer];
//    //manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    manager.requestSerializer.timeoutInterval = 30;
//    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//    
//    [manager POST:@"https://api.cn.rong.io/user/getToken.json"  parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"success");
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"failure");
//    }];
//    
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.cn.rong.io/user/getToken.json"]];
//    [request setHTTPMethod:@"POST"];
//    [request setTimeoutInterval:60];
//    [request setAllHTTPHeaderFields:nil];
//    
//    //NSString *bodyStr = @"access_token=xxxxx&status=微博内容";
//    //NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
//    //[request setHTTPBody:bodyData];
//
//    
//    
//    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"123");
//        
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        
//        NSLog(@"dic:%@",dict);
//        
//    }];
//    [task resume];
    
//    return YES;
    
    //注册微信
    [WXApi registerApp:@"wx4bf9f0896575b0e9"];
    
    // Override point for customization after application launch.
    [[RCIM sharedRCIM] initWithAppKey:@"uwd1c0sxdu5e1"];
    
    //记住放在融云初始化的后面
    
    [self handleIMToken];
    
    
    
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
        self.firstNavigationController = (MyENavigationController *)[tabBarController.viewControllers objectAtIndex:2];//这个viewControllers里装的是NavigationController而不是viewController吗？略神奇 其实我觉得应该是类似于实例化
        
        //游戏规则
        //做过才能理解
        JokeViewController *jvc = [[JokeViewController alloc] init];
        
        self.firstNavigationController.viewControllers = @[jvc];
        //tabBarController里的viewcontrollers装的是navigationController；
        //navigationController里的viewControllers装的是viewcontroller
        
        //设置第二个Controller
        self.secondNavigationController = (MyENavigationController *)[tabBarController.viewControllers objectAtIndex:1];
        
        NewsViewController *nvc = [[NewsViewController alloc] initWithStyle:@"新闻" noteList:nil];
        self.secondNavigationController.viewControllers = @[nvc];
        //设置第三个Controller
        self.thirdNavigationController = (MyENavigationController *)[tabBarController.viewControllers objectAtIndex:0];
        WeatherViewController *wvc = [[WeatherViewController alloc] init];
        self.thirdNavigationController.viewControllers = @[wvc];
        
        //设置第四个Controller
        self.fourNavigationController = (MyENavigationController *)[tabBarController.viewControllers objectAtIndex:3];
        NoteViewController *novc = [[NoteViewController alloc] initWithHistoryObject:nil isShowHistoryObject:NO];
        
        self.fourNavigationController.viewControllers = @[novc];
        
        //设置第五个Controller
        self.fiveNavigationController = (MyENavigationController *)[tabBarController.viewControllers objectAtIndex:4];
        MineViewController *mvc = [[MineViewController alloc] init];
        
        self.fiveNavigationController.viewControllers = @[mvc];


        
    }
    
    return YES;
}


//判/取/存融云的token，id，名字值
- (void) handleIMToken{
    
    NSUserDefaults *defaultsIM = [NSUserDefaults standardUserDefaults];
//    [defaults setInteger:10 forKey:@"Age"];
    
//    UIImage *image =[UIImage imageNamed:@"somename"];
//    NSData *imageData = UIImageJPEGRepresentation(image, 100);//把image归档为NSData
//    [defaults setObject:imageData forKey:@"image"];
    
//    [defaults synchronize];
    
//    其中，方法synchronise是为了强制存储，其实并非必要，因为这个方法会在系统中默认调用，但是你确认需要马上就存储，这样做是可行的。
    
    [defaultsIM objectForKey:saveIMKey];
    
    if ([defaultsIM isKindOfClass:[IMUser class]]){
        
        NSLog(@"获取融云token成功");
        
    }else {
        
        [self saveIMUser];
        

    }
    

}

- (void)saveIMUser{
    
   
    IMUser *user = [[IMUser alloc] init];
    int random = arc4random()%10000000 +1;
    user.imUserId = [NSString stringWithFormat:@"user%d",random];
    user.imUserName = [NSString stringWithFormat:@"用户%d",random];
    
    [JuHeService queryIMTokenWithDelegate:nil userId:user.imUserId name:user.imUserName completion:^(NSString *token){
        
        if([token isEqualToString:@""] == NO){
            
            user.imUserToken = token;
            
            user.imIsSave = YES;
            
            //将自定义的IMUser类型变为Nsdata类型，为了能让NsUserdefault存
            NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:userData forKey:saveIMKey];
            
            NSNotification * notification = [NSNotification notificationWithName:IMSave object:userData];
        
            
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"test_name" object:userData userInfo:<#(nullable NSDictionary *)#>];
            
            
        }else{
            
            user.imIsSave = NO;
        }
    }];
    
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

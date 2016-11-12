//
//  MyENavigationController.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/11/12.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "MyENavigationController.h"

@interface MyENavigationController ()

@end

@implementation MyENavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//其实完全没有这个必要，因为你要知道，你Push 和Back 都是通过NavigationController来做到的。

//因为push是压入到栈中，后来者居上：

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //判断当前控制器中的自控制器个数
    NSLog(@"test ______%lu",(unsigned long)[self.viewControllers count]);
//    if (self.viewControllers.count > 0) {
//        //进入到次级界面count大于1，这时隐藏
//        self.tabBarController.tabBar.hidden = YES;
//    }
    if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        //这种隐藏tabbar不单隐藏而且不会占空间，而且跳回第一个还可以显示出来，棒棒哒
        viewController.hidesBottomBarWhenPushed = YES;
        //这种隐藏tabbar不单隐藏而且会占空间
        //        self.tabBarController.tabBar.hidden = YES;

    }
    [super pushViewController:viewController animated:animated];
}

//再重写返回的方法：

- ( UIViewController *)popViewControllerAnimated:(BOOL)animated{
    NSLog(@"testt_____%lu",(unsigned long)[self.viewControllers count]);
//    if (self.viewControllers.count ==1 ) {
//        self.tabBarController.tabBar.hidden = NO;
//    }
    //针对这种父类方法有返回值的，直接重写的时候返回就行了，因为调用这种方法本身就会有个返回值
    return [super popViewControllerAnimated:animated];
}

@end

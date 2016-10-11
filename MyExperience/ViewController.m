//
//  ViewController.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/9/7.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "ViewController.h"
#import "twoViewController.h"
#import "QQViewController.h"
#import "SqliteViewController.h"
#import "JuHeService.h"


@interface ViewController ()<JuHeServiceDelegate>
@property (strong, nonatomic) NSArray *dataList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MyWorld";
    
    [self setupRightTopButton];
}
- (IBAction)clickNetButton:(id)sender {
    
    [JuHeService queryJuheDataWithDelegate:self
                              Sort:@"desc"
                              page:1
                          pageSize:20
                              time:[NSDate date]
                            appKey:@"e2f6edd4efbde4f44cb30b6f5874f4db"];
    
}

- (void)getDataWithReson:(NSString *)reason
                dataList:(NSArray *)dataList{
    if ([reason isEqualToString:@"Success"]){
        
        _dataList = dataList;
    }
}

- (void)setupRightTopButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 100, 30);
    
    [btn setTitle:@"推荐奖励" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    UIBarButtonItem *rewardItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
//    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    
//    spaceItem.width = -15;
    
    [btn addTarget:self action:@selector(shareButton) forControlEvents:UIControlEventTouchUpInside];
    
//    self.navigationItem.rightBarButtonItems = @[spaceItem,rewardItem];
    self.navigationItem.rightBarButtonItems = @[rewardItem];
    

}

- (void)shareButton{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickQQLikeButton:(id)sender {
    
    QQViewController *vc = [[QQViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (IBAction)ClickIM:(id)sender {
    

    
    [[RCIM sharedRCIM] connectWithToken:@"61sGPMme9URINXS9sd5vSh/brDdDzZV10PC0CjArKtSehqFGnx7XDtInOUSHVvSLKSRmhEkqXXI68GnBr9bG8WQUWf7ditT4" success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //新建一个聊天会话View Controller对象
            RCConversationViewController *chat = [[RCConversationViewController alloc]init];
            //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
            chat.conversationType = ConversationType_PRIVATE;
            //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
            chat.targetId = @"tester1";
            //设置聊天会话界面要显示的标题
            chat.title = @"想显示的会话标题";
            //显示聊天会话界面
            [self.navigationController pushViewController:chat animated:YES];
        });
        

        
//        twoViewController *conversationVC = [[twoViewController alloc]init];
//        conversationVC.conversationType = ConversationType_PRIVATE;
//        conversationVC.targetId = @"tester1";
//        conversationVC.title = @"test1";
//        
//        [self.navigationController pushViewController:conversationVC animated:YES];
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%d", status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
    

}
- (IBAction)clickSqliteViewController:(id)sender {
    
    SqliteViewController *svc = [[SqliteViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
    
}

@end

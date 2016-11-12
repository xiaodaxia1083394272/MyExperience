//
//  ChatViewController.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/11/12.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    
//    您需要设置在会话列表界面显示哪些类型的会话，以及将哪些类型的会话在会话列表中聚合显示。
//    聚合显示指的是此类型所有会话，在会话列表中聚合显示成一条消息，点击进去会再显示此类型的具体会话列表。
}

//3、点击会话列表，进入聊天会话界面
//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = @"想显示的会话标题";
    [self.navigationController pushViewController:conversationVC animated:YES];
}

//-(void)loginRongCloudWithUserInfo:(RCUserInfo *)userInfo withToken:(NSString *)token{
//    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
////        [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor redColor];
//        NSLog(@"login success with userId %@",userId);
//        //同步好友列表
////        [self syncFriendList:^(NSMutableArray *friends, BOOL isSuccess) {
////            NSLog(@"%@",friends);
////            if (isSuccess) {
////                [self syncGroupList:^(NSMutableArray *groups, BOOL isSuccess) {
////                    if (isSuccess) {
////                        NSLog(@" success 发送通知");
////                        [[NSNotificationCenter defaultCenter] postNotificationName:@"alreadyLogin" object:nil];
////                    }
////                }];
//////
////            }
//        }];
//        
//        
////        [RCIMClient sharedRCIMClient].currentUserInfo = userInfo;
////        [[RCDataManager shareManager] refreshBadgeValue];
//    } error:^(RCConnectErrorCode status) {
//        NSLog(@"status = %ld",(long)status);
//    } tokenIncorrect:^{
//        
//        NSLog(@"token 错误");
//    }];
//    
//    
//    
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  MineViewController.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/11/11.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "MineViewController.h"
#import "DiscoverHomeCell.h"
#import "UIColor+HexColor.h"

#import "ChatViewController.h"

#import "WXApi.h"

#import "WechatAuthSDK.h"

#import "WXApiObject.h"
#import "CommonDefine.h"

#import "IMUser.h"

#import "JuHeService.h"

#import "VideoViewController.h"






@interface MineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (strong, nonatomic) NSArray *discoverList;

@property (assign, nonatomic) BOOL imIsConnect;


@end

@implementation MineViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXShare" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMSave object:nil];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        
        // 接收分享回调通知
        //监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"WXShare" object:nil];
        
        
        // 检查是否装了微信
        if ([WXApi isWXAppInstalled])
        {
            
        }
        
        //融云请求token状况通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveIMResult:) name:IMSave object:nil];
    }
    return self;
}

- (void)getOrderPayResult:(NSNotification *)notification
{
    // 注意通知内容类型的匹配
    if (notification.object == 0)
    {
        NSLog(@"分享成功");
    }
}

- (void)saveIMResult:(NSNotification *)notification{
    
//    notification.object
    NSLog(@"理论上讲请求token成功");
    
    __weak __typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"获取融云token成功，是否跳转聊天"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    UIAlertAction *requestAction = [UIAlertAction actionWithTitle:@"是"style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
        [weakSelf saveIMUser];
    }];
    
    [alertController addAction:cancelAction];

    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)jumpToIMConversation{
    
    if(_imIsConnect){
        
        RCConversationViewController *cc = [[RCConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:@"test2"];
        [self.navigationController pushViewController:cc animated:YES];
    }else{
        
        NSLog(@"连接融云对话不成功");
    }
    
}

//融云连接成功后，就不用多次连
- (void)connectIM{
    
    self.imIsConnect = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData * userData = [defaults objectForKey:saveIMKey];
    
    IMUser *imUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    
    [[RCIM sharedRCIM] connectWithToken:imUser.imUserToken success:^(NSString *userId) {
        
        dispatch_async(dispatch_get_main_queue(),^{
            

            self.imIsConnect = YES;
            
        });
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"status = %ld",(long)status);
        
        self.imIsConnect = NO;
        
    } tokenIncorrect:^{
        
        self.imIsConnect = NO;
        NSLog(@"token 错误");
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    
    [self connectIM];
    
    NSArray *oneArray = [NSArray arrayWithObjects:@"给作者留言",@"video", nil];
    NSArray *twoArray = [NSArray arrayWithObjects:@"微信分享",@"", nil];
    _discoverList = [[NSArray alloc] initWithObjects:oneArray,twoArray, nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)WXShare{
    
    /**
     scene: 发送的目标场景,可以选择发送到会话(WXSceneSession)或者朋友圈(WXSceneTimeline),默认发送到会话.
     1.分享或收藏的目标场景，通过修改scene场景值实现。
     2.发送到聊天界面——WXSceneSession
     3.发送到朋友圈——WXSceneTimeline
     4.添加到微信收藏——WXSceneFavorite
     */
    
    /** bText:
     发送消息的类型.包括文本消息和多媒体消息两种.两者只能选择其一.不能同时发送文本和多媒体消息.
     
     */
    
    //1,分享文字
    //    SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
    //    req.text = @"分享的内容";
    //    req.bText = YES;
    //    req.scene = WXSceneSession;
    //    [WXApi sendReq:req];
    
    //2.图片类型分享
    /**  WXMediaMessage 多媒体分享的类
     1. setThumbImage 设置缩略图
     */
    //    WXMediaMessage * message = [WXMediaMessage message];
    //    [message setThumbImage:[UIImage imageNamed:@"black"]];
    //
    //    WXImageObject * imageObject = [WXImageObject object];
    //    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"seeall@1x" ofType:@"png"];
    //    imageObject.imageData = [NSData dataWithContentsOfFile:filePath];
    //    message.mediaObject = imageObject;
    //
    //    SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
    //    req.bText = NO;
    //    req.message = message;
    //    req.scene = WXSceneSession;
    //    [WXApi sendReq:req];
    
    //3.网页类型分享
    WXMediaMessage * message = [WXMediaMessage message];
    message.title = @"应用分享";
    message.description = @"这是一个挺不错的APP，赶紧下载吧！";
    //    [message setThumbImage:[UIImage imageNamed:@"seeall@1x"]];
    
    WXWebpageObject * webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = @"http://itunes.apple.com/cn/app/id1167035979";
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
    

}

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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_discoverList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *list = _discoverList[section];
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *list = _discoverList[indexPath.section];
//    Discover *discover = list[indexPath.row];
    
    DiscoverHomeCell *cell = [DiscoverHomeCell cellWithTableView:tableView];
    BOOL isLast = (indexPath.row == [list count] - 1 ? YES : NO);
    
    [cell updateCell:list[indexPath.row]  iconImageUrl:nil indexPath:indexPath isLast:isLast];
    
    //防止循环引用
    typeof(cell) __weak weakCell = cell;

    cell.option=^{
//        NSURL *url = [NSURL URLWithString:discover.link];
//        if ([GoSportUrlAnalysis isGoSportScheme:url]) {
//            [GoSportUrlAnalysis pushControllerWithUrl:url NavigationController:self.navigationController];
//        } else {
//            SportWebController *controller = [[SportWebController alloc] initWithUrlString:discover.link title:discover.name];
//            [self.navigationController pushViewController:controller animated:NO];
//        }
        if ([weakCell.valueLabel.text isEqualToString:@"给作者留言"]){
            
            [self jumpToIMConversation];
           
        }else if ([weakCell.valueLabel.text isEqualToString:@"微信分享"]){
            
            [self WXShare];
            
        }else if ([weakCell.valueLabel.text isEqualToString:@"调用短信"]){
            
            [self testCall];
        }else if ([weakCell.valueLabel.text isEqualToString:@"video"]) {
            
            VideoViewController *vvc = [[VideoViewController alloc] init];
            [self.navigationController pushViewController:vvc animated:YES];
            
        }
    };
    
    return cell;
    
}

- (void)testCall{
    
//    NSString *stringURL = @"sms:+12345678901";
//    NSURL *url = [NSURL URLWithString:stringURL];
//    [[UIApplication sharedApplication] openURL:url];
    NSURL *url = [NSURL URLWithString:@"testurl"];
    [[UIApplication sharedApplication] openURL:url];
}
//断开与融云的连接
//[[RCIM sharedRCIM] disconnect:YES]
//断开是否接受远程推送
//- (void)disconnect:(BOOL)isReceivePush;
//登出
//- (void)logout;
#pragma mark - 融云处理
- (void) handleIM{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:saveIMKey];
    
    IMUser *imUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if (imUser.imUserToken != nil && [imUser.imUserToken isEqualToString:@""] == NO){
        
        NSLog(@"融云已获得");
    }else {
        
        [self IMAlert];
    }
    
}

-(void)IMAlert{
    __weak __typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否重新请求获取融云token"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    UIAlertAction *requestAction = [UIAlertAction actionWithTitle:@"重试"style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
        [weakSelf saveIMUser];
    }];
    
    [alertController addAction:cancelAction];
    
    [alertController addAction:requestAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
            
            NSNotification * notification = [NSNotification notificationWithName:IMSave object:user];
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            
        }else{
            
            user.imIsSave = NO;
        }
    }];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 55;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //加这个东西其实主要为了调背景颜色的
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 15)];
    v.backgroundColor = [UIColor hexColor:@"f5f5f9"];
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[DiscoverHomeCell class]]){
        
        DiscoverHomeCell *discoverHomeCell = (DiscoverHomeCell *)cell;
        if (discoverHomeCell.option){
            discoverHomeCell.option();
        }
    }
    
}

@end

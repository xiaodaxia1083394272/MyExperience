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





@interface MineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (strong, nonatomic) NSArray *discoverList;


@end

@implementation MineViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXShare" object:nil];
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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    NSArray *oneArray = [NSArray arrayWithObjects:@"给作者留言", nil];
    NSArray *twoArray = [NSArray arrayWithObjects:@"微信分享", nil];
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
            
            [[RCIM sharedRCIM] connectWithToken:@"sR6mlx+RRJQXjvaF2xWo8y+fk98IrGNYOwlaUzgjtrYhCmG+nHKTx9zyOY3opCw+H6fG/uEX08u+5z4AxHYAbA==" success:^(NSString *userId) {
                
                dispatch_async(dispatch_get_main_queue(),^{
                   
                    RCConversationViewController *cc = [[RCConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:@"test2"];
                    [self.navigationController pushViewController:cc animated:YES];
                    

                });

            } error:^(RCConnectErrorCode status) {
            NSLog(@"status = %ld",(long)status);
        } tokenIncorrect:^{
            
            NSLog(@"token 错误");
        }];
            
           
        }else if ([weakCell.valueLabel.text isEqualToString:@"微信分享"]){
            
            [self WXShare];
            
        }
    };
    
    return cell;
    
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

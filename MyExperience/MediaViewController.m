//
//  MediaViewController.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/27.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "MediaViewController.h"
//导入苹果官方的播放器头文件
//主要封装了音频视频的播放类
//封装了播放音频视频的编码解码基础类库
#import <MediaPlayer/MediaPlayer.h>

@interface MediaViewController ()

//定义一个播放器对象
@property (strong,nonatomic) MPMoviePlayerController *playerController;
//@property (strong, nonatomic) AVPlayerViewController *playerViewController;

@end

@implementation MediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)clickMedioPlayButton:(id)sender {
    
//    NSString *strURL = @"http://www.wasu.cn/Play/show/id/7559999?refer=video.baidu.com";
//    NSURL *url = [NSURL URLWithString:strURL];
//    _playerController = [[MPMoviePlayerController alloc] initWithContentURL:url];
//    _playerController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 2);
//
//    [self.view addSubview:_playerController.view];
//    
//    //视频下载后的处理编解码的过程
//    [_playerController play];
//    
//    AVPlayerViewController *player = [[AVPlayerViewController alloc]init];
//    player.player = [[AVPlayer alloc]initWithURL:movieUrl];
//    [self presentViewController:player animated:YES completion:nil];
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

@end

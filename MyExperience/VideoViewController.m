//
//  VideoViewController.m
//  MyExperience
//
//  Created by HMRL on 16/12/15.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>

#import <MediaPlayer/MediaPlayer.h>

@interface VideoViewController ()

//要注意视频播放和音频播放雷同，也需要把视频播放器设置为全局变量
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) MPMoviePlayerController *playerController;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self videoReady];
//    [self testVideo];
}

//旧的方式
- (void)testVideo{
    
    
    NSString *strURL = @"http://v.cctv.com/flash/mp4video6/TMS/2011/01/05/cf752b1c12ce452b3040cab2f90bc265_h264818000nero_aac32-1.mp4";
    NSURL *url = [NSURL URLWithString:strURL];
    
    //这个好像只能解析mp4.格式的
    _playerController = [[MPMoviePlayerController alloc]initWithContentURL:url];
    
    _playerController.view.frame = self.view.bounds;
    
    //视频下载后的编解码的处理
    [_playerController prepareToPlay];
    [self.view addSubview:_playerController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)videoReady{
    
    //   1 创建要播放的元素
    
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"视频文件名" withExtension:nil];
    NSString *urlString = @"http://v.cctv.com/flash/mp4video6/TMS/2011/01/05/cf752b1c12ce452b3040cab2f90bc265_h264818000nero_aac32-1.mp4";

    
    NSURL *urlForMac = [NSURL URLWithString:urlString];
    //    playerItemWithAsset:通过设备相册里面的内容 创建一个 要播放的对象    我们这里直接选择使用URL读取
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:urlForMac];
    
    //    duration   当前播放元素的总时长
    //    status  加载的状态          AVPlayerItemStatusUnknown,  未知状态
    //    AVPlayerItemStatusReadyToPlay,  准备播放的状态
    //    AVPlayerItemStatusFailed   失败的状态
    
    //    时间控制的类目
    //    current
    //    forwordPlaybackEndTime   跳到结束位置
    //    reversePlaybackEndTime    跳到开始位置
    //    seekToTime   跳到指定位置
    
    //2  创建播放器
    self.player = [AVPlayer playerWithPlayerItem:item];
    //也可以直接WithURL来获得一个地址的视频文件
    //    externalPlaybackVideoGravity    视频播放的样式
    //AVLayerVideoGravityResizeAspect   普通的
    //    AVLayerVideoGravityResizeAspectFill   充满的
    //    currentItem  获得当前播放的视频元素
    self.player.externalPlaybackVideoGravity = AVLayerVideoGravityResizeAspect;
    
    //    3  创建视频显示的图层
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
    layer.frame = self.view.bounds;
    // 显示播放视频的视图层要添加到self.view的视图层上面
    [self.view.layer addSublayer:layer];
    
    //最后一步开始播放
    [self.player play];
}

@end

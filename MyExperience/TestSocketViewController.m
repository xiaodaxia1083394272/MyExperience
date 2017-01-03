//
//  TestSocketViewController.m
//  MyExperience
//
//  Created by HMRL on 16/12/27.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "TestSocketViewController.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"

@interface TestSocketViewController ()<GCDAsyncSocketDelegate>{
    
    GCDAsyncSocket *privateSocket;
    NSString *p_host;
    uint16_t p_port;
}
@property (strong,nonatomic) GCDAsyncSocket *Socket;


@end

@implementation TestSocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //申明一个socket的成员变量
    GCDAsyncSocket *Socket;
    //在viewDidLoad中创建socket对象
    GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    self.Socket = socket;
    //连接服务端
    NSError *error = nil;
    [privateSocket connectToHost:p_host onPort:p_port error:&error];
    if (!error){
        NSLog(@"本地socket连接服务端socket成功");
    }else
    {
        NSLog(@"error--%@",error);
    }

    
}

//接收数据一切业务处理主要再其代理的方法中实现的
//连接成功 ---只要连接成功就回调
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    
}
//断开连接---与服务器断开就回调
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    
}

// Called when a socket has completed writing the requested data
//向服务器发送成功的时候回调
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
}
//接收服务器传过来的数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [_Socket readDataWithTimeout:-1 tag:0];
    
    char Buf[16384];
    char *by = (char *)[data bytes];
    memcpy(&Buf[0], by , data.length);
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *reStr = [[NSString alloc] initWithData:data encoding:enc];
    NSData *reData = [reStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [[NSString alloc] initWithData:reData encoding:NSUTF8StringEncoding];

    
    NSLog(@"-------%@",[NSString stringWithCString:str encoding:enc]);
}

- (void)query{
    [_Socket writeData:[NSData dataWithBytes:p_charSeData[p_intSeSequence] length:p_intSeCount[p_intSeSequence][1]] withTimeout:-1 tag:0];
}
- (void)startAsync{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread currentThread].name = @"P_mainSendMessage";
        
        while(TRUE)
        {
            sleep(1);
            //这里发送数据
        }
        
        });
    }


@end

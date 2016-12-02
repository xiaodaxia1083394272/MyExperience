//
//  BaiduViewController.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/26.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "BaiduViewController.h"

@interface BaiduViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *dataWebView;

@end

@implementation BaiduViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURL *url = [NSURL URLWithString:@"http://geek.csdn.net/news/detail/118070"];
    [self.dataWebView loadRequest:[NSURLRequest requestWithURL:url]];
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

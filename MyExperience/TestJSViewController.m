//
//  TestJSViewController.m
//  MyExperience
//
//  Created by HMRL on 16/12/9.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "TestJSViewController.h"

@interface TestJSViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *testWebView;

@end

@implementation TestJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.testWebView.delegate = self;
    NSURL *url =[[NSURL alloc]
                 initWithString:@"http://www.baidu.com"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.testWebView loadRequest:request];
    // Do any additional setup after loading the view from its nib.
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

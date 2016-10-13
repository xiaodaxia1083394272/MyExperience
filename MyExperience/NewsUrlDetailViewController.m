//
//  NewsUrlDetailViewController.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/13.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "NewsUrlDetailViewController.h"

@interface NewsUrlDetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *dataWebView;
@property (strong, nonatomic) NewObject *newsObject;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@end

@implementation NewsUrlDetailViewController

- (instancetype)initWithNewObjectForWebView:(NewObject *)newsObject {
    self = [super init];
    if (self) {
        self.newsObject = newsObject;
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.activityView.hidesWhenStopped = YES;
    [self.activityView startAnimating];
    NSURL *url = [NSURL URLWithString:_newsObject.newsUrl];
    [self.dataWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.activityView stopAnimating];
}


@end

//
//  NewsDetailViewController.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/13.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()<UIScrollViewDelegate,UITextViewDelegate>
@property (strong, nonatomic) NewObject *newsObject;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollerView;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) NSArray *imageUrlArray;

@end

@implementation NewsDetailViewController

- (instancetype)initWithNewObject:(NewObject *)newsObject {
    self = [super init];
    if (self) {
        self.newsObject = newsObject;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"新闻详情";
    self.detailTextView.text = _newsObject.title;
    self.imageUrlArray = @[_newsObject.pictrueOneUrl,_newsObject.pictrueTwoUrl,_newsObject.pictrueThreeUrl];
    
    [self updateScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateScrollView {
    double contentWidth = [UIScreen mainScreen].bounds.size.width;

    
    self.imageScrollerView.contentSize = CGSizeMake(contentWidth *3, _imageScrollerView.bounds.size.height);
    for (int i = 0;i<3; i++){
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_imageScrollerView.bounds.origin.x + contentWidth *i, _imageScrollerView.bounds.origin.y,contentWidth, _imageScrollerView.bounds.size.height)];
//        imageView.backgroundColor = [UIColor yellowColor];
        
        NSURL *imageUrl = [NSURL URLWithString:self.imageUrlArray[i]];
        NSLog(@"%d的URL%@",i,imageUrl);
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        imageView.image = image;
        [self.imageScrollerView addSubview:imageView];
    }
    
}



@end

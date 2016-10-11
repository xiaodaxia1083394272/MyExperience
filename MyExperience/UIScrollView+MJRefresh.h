//
//  UIScrollView+MJRefresh.h
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/12.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (MJRefresh)
//添加下拉刷新效果
- (void)addPullDownReloadWithTarget:(id)target action:(SEL)action;

//添加上拉加载更多效果
- (void)addPullUpLoadMoreWithTarget:(id)target action:(SEL)action;

//开始刷新
- (void)beginReload;

//开始加载更多
- (void)beginLoadMore;

//结束刷新和加载
- (void)endLoad;

//设置能加载更多
- (void)canLoadMore;

//设置不能加载更多
- (void)canNotLoadMore;

@end

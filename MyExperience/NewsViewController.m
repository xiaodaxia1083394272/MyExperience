
//  NewsViewController.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/10.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "NewsViewController.h"
#import "NoteViewController.h"
#import "BaiduViewController.h"


@interface NewsViewController ()<JuHeServiceDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *dataList;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (copy, nonatomic) NSString *styleString;
@property (strong, nonatomic) NSArray *notelist;
@property (weak, nonatomic) IBOutlet UIView *shieldView;

@end

@implementation NewsViewController

- (instancetype)initWithStyle:(NSString *)style noteList:(NSArray *)noteList {
    self = [super init];
    if (self) {
        
        self.styleString = style;
        self.notelist = noteList;
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self.styleString isEqualToString:@"新闻"]) {
        self.title =@"头条新闻";
        self.shieldView.hidden = YES;
        
        [self setRightBarButton];
        [self setLeftBarButton];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.dataTableView.bounds];
        int random = arc4random()%7 +1;
        NSString *randomString = [NSString stringWithFormat:@"%d.jpg",random];
        
        imageView.image = [UIImage imageNamed:randomString];
        imageView.alpha = 0.3;
        self.dataTableView.backgroundView = imageView;

        [self.dataTableView addPullDownReloadWithTarget:self action:@selector(queryData)];
        //一开始就下拉刷新
        [self.dataTableView beginReload];
        
    }else if ([self.styleString isEqualToString:@"note"]) {
        self.title = @"笔记历史";
        self.shieldView.hidden = YES;
        
        UIImageView *uiv = [[UIImageView alloc] initWithFrame:self.dataTableView.bounds];
        uiv.image = [UIImage imageNamed:@"tree"];
        self.dataTableView.backgroundView = uiv;
        
        [self.dataTableView reloadData];
        
    }
}

- (void)setLeftBarButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 100, 30);
    
    //    [btn setImage:[UIImage imageNamed:@"rightUp"] forState:UIControlStateNormal];
    
    [btn setTitle:@"清理缓存" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    UIBarButtonItem *rewardItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    spaceItem.width = -15;
    
    [btn addTarget:self action:@selector(clickCleanButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = @[spaceItem,rewardItem];
}

- (void)setRightBarButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 100, 30);
    
    //    [btn setImage:[UIImage imageNamed:@"rightUp"] forState:UIControlStateNormal];
    
    [btn setTitle:@"百度一下" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    UIBarButtonItem *rewardItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    spaceItem.width = -15;
    
    [btn addTarget:self action:@selector(clickBaiDuButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[spaceItem,rewardItem];
}

- (void)clickBaiDuButton{
    BaiduViewController *bc = [[BaiduViewController alloc] init];
    [self.navigationController pushViewController:bc animated:YES];
    
}
- (void)clickCleanButton{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                       
//                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//                       
//                       NSLog(@"%@", cachPath);
//                       
//                       
//                       
//                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
//                       
////                       NSLog(@"files :%d",[files count]);
//        
//                       for (NSString *p in files) {
//                           
//                           NSError *error;
//                           
//                           NSString *path = [cachPath stringByAppendingPathComponent:p];
//                           
//                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//                               
//                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
//                               
//                           }
//                           
//                       }
//                       
//                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
    // 清除缓存
    
    CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject]
    + [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSTemporaryDirectory()];
    
    NSString *message = size > 1 ? [NSString stringWithFormat:@"缓存%.2fM, 删除缓存", size] : [NSString stringWithFormat:@"缓存%.2fK, 删除缓存", size * 1024.0];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        [self cleanCaches];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:action];
    [alert addAction:cancel];
    [self showDetailViewController:alert sender:nil];
}

// 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path
{
    // 利用NSFileManager实现对文件的管理</span>
    
    NSFileManager *manager = [NSFileManager defaultManager]; CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M  
        return size / 1024.0 / 1024.0;   
    }   
    return 0;
}
- (void)cleanCaches
{
    [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject];//document
    [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject];//liabrary
    [self cleanCaches:NSTemporaryDirectory()];
}

// 根据路径删除文件
- (void)cleanCaches:(NSString *)path
{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }  
}

//-(void)clearCacheSuccess
//
//{
//
//    NSLog(@"清理成功");
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)queryData{
    
    [JuHeService queryJuheNewsDataWithDelegate:self appkey:@"944300d96ee3ceaaebc7486a2a213e5b" type:@"top"];
}

- (void)getDataWithReason:(NSString *)reason
           newsObjectList:(NSMutableArray *)newsObjectList{
    
    if ([reason isEqualToString:@"成功的返回"]){
        
        _dataList = newsObjectList;
        
        [self.dataTableView reloadData];
        
        
    }
    
    [self.dataTableView endLoad];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.styleString isEqualToString:@"新闻"]) {
        
        return [self.dataList count];

    }else if ([self.styleString isEqualToString:@"note"]) {
        
        NSLog(@"note count  %lu",(unsigned long)[self.notelist count]);

        return [self.notelist count];
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"NewsTableViewCell";
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [NewsTableViewCell createCell];
        //        cell.delegate = self;
        
    }
    
    NewObject *newsObject = [self.dataList objectAtIndex:indexPath.row];
    
    if ([self.styleString isEqualToString:@"新闻"]) {
        
        [cell updateCellWithNewObject:newsObject];
        
        cell.imageWidthConstraint.constant = 45;
        cell.imageAndTitleWidthConstraint.constant = -15;
        
        NSURL *imageUrl = [NSURL URLWithString:newsObject.pictrueTwoUrl];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        cell.titleImage.image = image;


    }else if ([self.styleString isEqualToString:@"note"]){
        
        cell.imageWidthConstraint.constant = 0;
        cell.imageAndTitleWidthConstraint.constant = 0;
        [cell updateCellWithNoteObject:[self.notelist objectAtIndex:indexPath.row]];

    }
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NewsDetailViewController *controller = [[NewsDetailViewController alloc]initWithCourtJoinId: [(NewObject *)self.courtJoinList[indexPath.row] courtJoinId]];
    
//    NewsDetailViewController *controller = [[NewsDetailViewController alloc] initWithNewObject:(NewObject *)self.dataList[indexPath.row]];
    if ([self.styleString isEqualToString:@"新闻"]) {
        NewsUrlDetailViewController *ctl = [[NewsUrlDetailViewController alloc] initWithNewObjectForWebView:(NewObject *)self.dataList[indexPath.row]];
        
        [self.navigationController pushViewController:ctl animated:YES];
        
    }else if ([self.styleString isEqualToString:@"note"]){
        
        NoteViewController *nvc = [[NoteViewController alloc]initWithHistoryObject:[self.notelist objectAtIndex:indexPath.row]isShowHistoryObject:YES];
        [self.navigationController pushViewController:nvc animated:YES];
    }

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}


@end

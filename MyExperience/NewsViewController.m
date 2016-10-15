//
//  NewsViewController.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/10.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "NewsViewController.h"
#import "NoteViewController.h"

@interface NewsViewController ()<JuHeServiceDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *dataList;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (copy, nonatomic) NSString *styleString;
@property (strong, nonatomic) NSArray *notelist;
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
        
        UIImageView *uiv = [[UIImageView alloc] initWithFrame:self.dataTableView.bounds];
        uiv.image = [UIImage imageNamed:@"tree"];
        self.dataTableView.backgroundView = uiv;
        
        [self.dataTableView reloadData];
        
    }
}

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

//
//  JokeViewController.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/10.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "JokeViewController.h"
#import "JokeTableViewCell.h"
#import "JuHeService.h"
#import "UIScrollView+MJRefresh.h"




@interface JokeViewController ()<JuHeServiceDelegate,UITextViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) NSMutableArray *dataList;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (strong, nonatomic) UITextView *textView;
@property (assign,nonatomic) int page;
@property (strong, nonatomic) UIView *detailView;



@end

@implementation JokeViewController

#define PAGE_START  1
#define COUNT_ONE_PAGE  20


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"轻松一刻";
    [self.dataTableView addPullDownReloadWithTarget:self action:@selector(loadNewData)];
    [self.dataTableView addPullUpLoadMoreWithTarget:self action:@selector(loadMoreData)];
    
    //一开始就下拉刷新
    [self.dataTableView beginReload];
    
//    [self setRightBarButton];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)loadNewData {
    self.page = PAGE_START;
    [self queryData];
}

-(void)loadMoreData {
    self.page ++;
    [self queryData];
}

- (void)setRightBarButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 100, 30);
    
    //    [btn setImage:[UIImage imageNamed:@"rightUp"] forState:UIControlStateNormal];
    
    [btn setTitle:@"微信分享" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    UIBarButtonItem *rewardItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    spaceItem.width = -15;
    
    [btn addTarget:self action:@selector(clickWXShareButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[spaceItem,rewardItem];
}

- (void)clickWXShareButton{
    
    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)queryData{
    [JuHeService queryJuheDataWithDelegate:self
                                      Sort:@"desc"
                                      page:_page
                                  pageSize:COUNT_ONE_PAGE
                                      time:[NSDate date]
                                    appKey:@"e2f6edd4efbde4f44cb30b6f5874f4db"];
}

- (void)getDataWithReson:(NSString *)reason
                dataList:(NSArray *)dataList{
    if ([reason isEqualToString:@"Success"]){
        
        //这段代码是针对分页的时候用的，所谓的分页，其实每次返回来的数据都是20条，只是请求的页面不同，数据内容是不同的而已，量没变，如果只是单纯的 self.dataList = dataList;那么每次新数据会覆盖掉旧数据，量没变，如果想变，那么就需要用addObjectsFromArray在原来的基础上增添。
        
        if ([self.dataList count] == 0 || _page == PAGE_START){
            self.dataList = [NSMutableArray arrayWithArray:dataList];
        }else {
            [self.dataList addObjectsFromArray:dataList];
        }
        
        
        [self.dataTableView reloadData];

        if ([dataList count] < COUNT_ONE_PAGE){
            
            [self.dataTableView canNotLoadMore];
        }else {
            [self.dataTableView canLoadMore];
            
        }
    }
    [self.dataTableView endLoad];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"JokeTableViewCell";
    
    JokeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [JokeTableViewCell createCell];
//        cell.delegate = self;
        
    }
     NSString *jokeString = [self.dataList objectAtIndex:indexPath.row];
    [cell updateCellWithJokeString:jokeString indexPath:indexPath];

    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    CourtJoinDetailController *controller = [[CourtJoinDetailController alloc]initWithCourtJoinId: [(CourtJoin *)self.courtJoinList[indexPath.row] courtJoinId]];
    
//    [self.navigationController pushViewController:controller animated:YES];
    
    self.
    detailView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.detailView.backgroundColor = [UIColor whiteColor];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64-44)];

    
//    _textView.backgroundColor = [UIImage imageNamed:randomString];
    
    _textView.text = [self.dataList objectAtIndex:indexPath.row];
    _textView.delegate = self;
    _textView.font =[UIFont systemFontOfSize:24];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.editable = NO;
    _textView.selectable = NO;
    

    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    int random = arc4random()%7 +1; //这个1，应该是整体从0到6加1
    NSString *randomString = [NSString stringWithFormat:@"%d.jpg",random];
    
    imageView.image = [UIImage imageNamed:randomString];
    imageView.alpha = 0.4;
    
    [_detailView addSubview:imageView];
    [_detailView sendSubviewToBack:imageView];
    
    [_detailView addSubview:_textView];
    [_detailView bringSubviewToFront:_textView];

    
    [self.view addSubview:_detailView];
    
    UIButton *textViewButton = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    textViewButton.backgroundColor = [UIColor clearColor];
    [textViewButton addTarget:self action:@selector(clickTextView) forControlEvents:UIControlEventTouchUpInside];
    
    [_textView addSubview:textViewButton];
    [_textView bringSubviewToFront:textViewButton];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:176.0/255.0 green:224.0/255.0 blue:230.0/255.0 alpha:1];
//    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:176.0/255.0 green:224.0/255.0 blue:230.0/255.0 alpha:1];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)clickTextView{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.detailView removeFromSuperview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}
@end

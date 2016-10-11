//
//  SqliteViewController.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/9/12.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "SqliteViewController.h"
#import <sqlite3.h>
#import "LSPShop.h"


@interface SqliteViewController ()<UITableViewDataSource,UISearchBarDelegate,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *shops;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceLabel;
@property (nonatomic, assign) sqlite3 *sqlite;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SqliteViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addSearchBar];
    

}

- (void)addSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.frame = CGRectMake(0, 0, 320, 44);
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
}


- (void)createSQLite3
{
    //存储数据地址的设置
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"shops.sqlite"];
    //打开数据库，没有数据库系统会自动创建一个数据库
    int states = sqlite3_open(path.UTF8String, &_sqlite);
    if (states == SQLITE_OK) {
        
        NSLog(@"打开数据库成功");
        //创建数据库表
        const char *sql = "CREATE TABLE IF NOT EXISTS t_shop(id integer PRIMARY KEY,name text NOT NULL,price real);";
        char *errmsg = NULL;
        sqlite3_exec(self.sqlite, sql, NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"创建表失败");
        }
        
    }else{
        NSLog(@"打开数据库失败");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)SaveData:(id)sender {
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_shop(name,price) VALUES('%@',%f)",self.nameLabel.text,self.priceLabel.text.doubleValue];
    sqlite3_exec(self.sqlite, sql.UTF8String, NULL, NULL, NULL);
    
    
    //刷新表格
    LSPShop *shop = [[LSPShop alloc] init];
    shop.name = self.nameLabel.text;
    shop.price = self.priceLabel.text;
    [self.shops addObject:shop];
    [self.tableView reloadData];
}

#pragma mark---UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"SQLite3";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    LSPShop *shop = self.shops[indexPath.row];
    cell.textLabel.text = shop.name;
    cell.detailTextLabel.text = shop.price;
    
    return cell;
}

@end

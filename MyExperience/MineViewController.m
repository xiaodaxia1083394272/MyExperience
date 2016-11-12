//
//  MineViewController.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/11/11.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "MineViewController.h"
#import "DiscoverHomeCell.h"
#import "UIColor+HexColor.h"



@interface MineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (strong, nonatomic) NSArray *discoverList;


@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    NSArray *oneArray = [NSArray arrayWithObjects:@"给作者留言", nil];
    NSArray *twoArray = [NSArray arrayWithObjects:@"微信分享", nil];
    _discoverList = [[NSArray alloc] initWithObjects:oneArray,twoArray, nil];
    
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_discoverList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *list = _discoverList[section];
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *list = _discoverList[indexPath.section];
//    Discover *discover = list[indexPath.row];
    
    DiscoverHomeCell *cell = [DiscoverHomeCell cellWithTableView:tableView];
    BOOL isLast = (indexPath.row == [list count] - 1 ? YES : NO);
    
    [cell updateCell:list[indexPath.row]  iconImageUrl:nil indexPath:indexPath isLast:isLast];
    
    //防止循环引用
    typeof(cell) __weak weakCell = cell;

    cell.option=^{
//        NSURL *url = [NSURL URLWithString:discover.link];
//        if ([GoSportUrlAnalysis isGoSportScheme:url]) {
//            [GoSportUrlAnalysis pushControllerWithUrl:url NavigationController:self.navigationController];
//        } else {
//            SportWebController *controller = [[SportWebController alloc] initWithUrlString:discover.link title:discover.name];
//            [self.navigationController pushViewController:controller animated:NO];
//        }
        if ([weakCell.valueLabel.text isEqualToString:@"给作者留言"]){
            
            NSLog(@"1");
        }else if ([weakCell.valueLabel.text isEqualToString:@"微信分享"]){
            
            NSLog(@"2");
        }
    };
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 55;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //加这个东西其实主要为了调背景颜色的
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 15)];
    v.backgroundColor = [UIColor hexColor:@"f5f5f9"];
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[DiscoverHomeCell class]]){
        
        DiscoverHomeCell *discoverHomeCell = (DiscoverHomeCell *)cell;
        if (discoverHomeCell.option){
            discoverHomeCell.option();
        }
    }
    
}

@end

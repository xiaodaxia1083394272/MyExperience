//
//  WeatherViewController.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/10.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "WeatherViewController.h"
#import "JuHeService.h"
#import "WeatherDateView.h"
#import "UIScrollView+MJRefresh.h"


@interface WeatherViewController ()<JuHeServiceDelegate,UIScrollViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIScrollView *dataScrollView;
@property (strong, nonatomic) WeatherDateView *weatherDateView;
@property (copy, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSArray *dateList;
@property (copy, nonatomic) NSString *selectedDate;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *lifeTextView;
@end

@implementation WeatherViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"天气";
//    UITapGestureRecognizer *tapOneGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneAct:)];
//    
//    tapOneGes.numberOfTapsRequired = 1;
//    tapOneGes.numberOfTouchesRequired = 1;
//    
//    [self.view addGestureRecognizer:tapOneGes];
    
    int random = arc4random()%7 +1;
    NSString *randomString = [NSString stringWithFormat:@"%d.jpg",random];
    
    self.backgroundImage.image = [UIImage imageNamed:randomString];
    self.backgroundImage.alpha = 1;
  
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self queryData];


    // Do any additional setup after loading the view from its nib.
}

//- (void) tapOneAct:(UITapGestureRecognizer *)tap {
//    NSLog(@"单机插座");
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)queryData{
    
    [JuHeService queryJuheWeatherDataWithDelegate:self
                                         cityName:@"广州"
                                            dtype:nil
                                           appKey:@"60c6096ca706b901753cfc411fe95389"];
}
- (void)getDataWithReson:(NSString *)reason
                realTime:(realTime *)realTime
                    life:(Life *)life
       weatherFutureList:(NSArray *)weatherFutureList{
    
    if ([reason isEqualToString:@"successed!"]){
        
        self.dateList = weatherFutureList;
        [self initDataScrollView];
        self.temperatureLabel.text = realTime.temperature;
        self.updateTimeLabel.text = [NSString stringWithFormat:@"更新于:%@",realTime.updateTime];
        self.lifeTextView.text = [NSString stringWithFormat:@" 穿衣综合指数：%@。 \n穿衣指导：%@\n\n 感冒综合分析：%@。\n感冒预防：%@ \n\n 空调建议：%@。\n具体：%@。\n\n 运动指数：%@。\n建议：%@",life.chuanyi[0],life.chuanyi[1],life.ganmao[0],life.ganmao[1],life.kongtiao[0],life.kongtiao[1],life.yudong[0],life.yudong[1]];
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
   
    self.tabBarController.tabBar.hidden = NO;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    
    [self performSelector:@selector(hiddenTabBar) withObject:nil afterDelay:2.0f];
}

- (void)hiddenTabBar{
//    NSInteger a = self.view.tag;
//    if (a == 110){
//        
//        self.tabBarController.tabBar.hidden = YES;
// 
//    }

}

#define BASIC_DATE_TAG  100
-(void)initDataScrollView{
    
    for(UIView *subView in self.dataScrollView.subviews){
        if([subView isKindOfClass:[WeatherDateView class]]){
            [subView removeFromSuperview];
        }
        
    }
    int selectedIndex = 0;
    int index = 0;
    CGFloat space = 0;
    for (weatherFuture *wf in _dateList) {
        NSString *dateString = wf.dateString;
        if ([dateString isEqualToString:_selectedDate]) {
            selectedIndex = index;
        }
        
        self.weatherDateView = [WeatherDateView createWeatherDateViewWithHoldViewWidth:[UIScreen mainScreen].bounds.size.width];
        self.weatherDateView.tag = BASIC_DATE_TAG + index;
        self.weatherDateView.delegate = self;
        [self.weatherDateView updatView:wf isSelected:NO index:index];
//        [self.weatherDateView updateOriginX:space + index * (space + self.weatherDateView.frame.size.width)];
        
        self.weatherDateView.frame = CGRectMake(space + index * (space + self.weatherDateView.frame.size.width), self.weatherDateView.frame.origin.y, self.weatherDateView.frame.size.width, self.weatherDateView.frame.size.height);
        
        [self.dataScrollView addSubview:self.weatherDateView];
        index ++;
    }
    
    [self.dataScrollView setContentSize:CGSizeMake(space + index * (space + [WeatherDateView defaultSize].width), _dataScrollView.frame.size.height)];
    self.dataScrollView.showsHorizontalScrollIndicator = NO;
    
    if (selectedIndex > 3 && _dataScrollView.contentSize.width > _dataScrollView.frame.size.width) {
        CGFloat oneWidth = space + [WeatherDateView defaultSize].width;
        CGFloat xOffset = MIN(MAX(selectedIndex * oneWidth - 0.5 * oneWidth, 0),  _dataScrollView.contentSize.width - [UIScreen mainScreen].bounds.size.width);
        [self.dataScrollView setContentOffset:CGPointMake(xOffset, 0) animated:NO];
    }
}

- (void)updateDateHeaderScrollView
{
    NSArray *subViewList = [self.dataScrollView subviews];
    for (UIView *view in subViewList) {
        if ([view isKindOfClass:[WeatherDateView class]]) {
            WeatherDateView *bdv = (WeatherDateView *)view;
            if ([bdv.dateString isEqualToString:_selectedDate]){
                [bdv updateSelected:YES];
            } else {
                if (YES == bdv.isSelected) {
                    [bdv updateSelected:NO];
                }
            }
        }
    }
}


@end

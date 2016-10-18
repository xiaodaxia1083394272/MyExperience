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
#import <CoreLocation/CoreLocation.h>

@interface WeatherViewController ()<JuHeServiceDelegate,UIScrollViewDelegate,UITextViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIScrollView *dataScrollView;
@property (strong, nonatomic) WeatherDateView *weatherDateView;
@property (copy, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSArray *dateList;
@property (copy, nonatomic) NSString *selectedDate;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *lifeTextView;

//声明定位管理器，貌似很多成熟的API库，都有一个管理类
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (copy, nonatomic) NSString *currentCity;
@end

@implementation WeatherViewController

//注意：不要使用局部变量（创建位置管理器），因为局部变量的方法结束它就被销毁了。建议使用一个全局的变量，且只创建一次就可以了（使用懒加载）。
 #pragma mark-懒加载
//-(CLLocationManager *)locationManager
//{
//    if (_locationManager==nil) {
//        //1.创建位置管理器（定位用户的位置）
//        self.locationManager=[[CLLocationManager alloc]init];
//        //2.设置代理
//        self.locationManager.delegate=self;
//    }
//    return _locationManager;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"天气";
    //判断用户定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]){
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        

        //每隔多少米定位一次（这里的设置为任何的移动）
        self.locationManager.distanceFilter=kCLDistanceFilterNone;
        //设置定位的精准度，一般精准度越高，越耗电（这里设置为精准度最高的，适用于导航应用）.定位服务是比较耗电的，如果是做定位服务（没必要实时更新的话），那么定位了用户位置后，应该停止更新位置。
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation;
        //开启位置更新
        [self.locationManager startUpdatingLocation];
        
    }else {
        //不能定位用户的位置
        //1.提醒用户检查当前的网络状况
       //2.提醒用户打开定位开关
        /*从iOS 6开始，苹果在保护用户隐私方面做了很大的加强，以下操作都必须经过用户批准授权
         
         （1）要想获得用户的位置
         
         （2）想访问用户的通讯录、日历、相机、相册等
         
         当想访问用户的隐私信息时，系统会自动弹出一个对话框让用户授权
         */
        /*注意：一旦用户选择了“Don’t Allow”，意味着你的应用以后就无法使用定位功能，且当用户第一次选择了之后，以后就再也不会提醒进行设置。
         
         因此在程序中应该进行判断，如果发现自己的定位服务没有打开，那么应该提醒用户打开定位服务功能。
         
         CLLocationManager有个类方法可以判断当前应用的定位功能是否可用+ (BOOL)locationServicesEnabled;
         
         　　常用的方法：截图告诉用户，应该怎么打开授权
         　　
         2.开发者可以在Info.plist中设置NSLocationUsageDescription说明定位的目的(Privacy - Location Usage Description)
         
         这里的定位服务是基于网络的。通常定位服务可以是基于GPS、基站或者是网络的。
         */
    
    
    }
    //测试方法，计算两个位置之间的距离
    [self countDistance];

//    //每隔指定距离定位一次（米）
//    self.locationManager.distanceFilter = 1.0;
//    //定位精度，精度越高需要定位的时间越长，越耗电
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    
//    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
//    {
//        [self.locationManager requestAlwaysAuthorization]; // 永久授权
//        [self.locationManager requestWhenInUseAuthorization]; //使用中授权
//        
//        
//    }

    
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

//计算两个位置之间的距离
-(void)countDistance
{
    //根据经纬度创建两个位置对象
    CLLocation *loc1=[[CLLocation alloc]initWithLatitude:40 longitude:116];
    CLLocation *loc2=[[CLLocation alloc]initWithLatitude:41 longitude:116];
    //计算两个位置之间的距离
    CLLocationDistance distance=[loc1 distanceFromLocation:loc2];
    NSLog(@"(%@)和(%@)的距离=%fM",loc1,loc2,distance);
}

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
        //温度的那个小圆圈，直接打开输入法,从符号里面拖过来就可以了
        self.temperatureLabel.text = [NSString stringWithFormat:@"%@˚",realTime.temperature]; ;
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

#pragma mark - 实现定位代理更新位置成功回调
//这个是一个过期的方法，新方法如下
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    NSLog(@"经度：%f", newLocation.coordinate.longitude);
//    NSLog(@"纬度：%f", newLocation.coordinate.latitude);
//    NSLog(@"速度：%f 米/秒", newLocation.speed);
//    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        
//        NSDictionary *locationInfo = [[NSDictionary alloc]init];
//        for (CLPlacemark * placemark in placemarks) {
//            locationInfo = [placemark addressDictionary];
//        }
//        NSLog(@"%@",locationInfo);
//    }];
//}
// 当定位到用户的位置时，就会调用（调用的频率比较频繁）

//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    [locationManager stopUpdatingLocation];

    //locations数组里边存放的是CLLocation对象，一个CLLocation对象就代表着一个位置
    CLLocation *loc = [locations firstObject];
    
    //维度：loc.coordinate.latitude
    //经度：loc.coordinate.longitude
    NSLog(@"纬度=%f，经度=%f",loc.coordinate.latitude,loc.coordinate.longitude);
    NSLog(@"%d",locations.count);
    
    //停止更新位置（如果定位服务不需要实时更新的话，那么应该停止位置的更新）
    //    [self.locMgr stopUpdatingLocation];
    
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            _currentCity = placeMark.locality;
            if (!_currentCity) {
                _currentCity = @"无法定位当前城市";
            }
            NSLog(@"%@",_currentCity); //这就是当前的城市
            NSLog(@"%@",placeMark.name);//具体地址:  xx市xx区xx街道
        }
        else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        }
        else if (error) {
            NSLog(@"location error: %@ ",error);
        }
        
    }];
    
    
}

//定位代理失败回调
//定位失败弹出提示框,点击"打开定位"按钮,会打开系统的设置,提示打开定位服务

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开定位设置
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];

}


@end

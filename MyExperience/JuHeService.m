//
//  JuHeService.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/9/26.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "JuHeService.h"
#import "realTime.h"

@interface JuHeService()


@end

@implementation JuHeService

+ (void)queryJuheDataWithDelegate:(id<JuHeServiceDelegate>)delegate
                             Sort:(NSString *)sort
                             page:(int)page
                         pageSize:(int)pageSize
                             time:(NSDate *)queryTime
                           appKey:(NSString *)appKey{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        NSMutableDictionary *inputDic = [NSMutableDictionary dictionary];
        [inputDic setValue:sort forKey:@"sort"];
        [inputDic setValue:[@(page) stringValue] forKey:@"page"];
        [inputDic setValue:[@(pageSize) stringValue] forKey:@"pagesize"];
        [inputDic setValue:[@((int)[queryTime timeIntervalSince1970]) stringValue] forKey:@"time"];
        [inputDic setValue:appKey forKey:@"key"];
        
//        [[JuHeService shareManager]aFGetDataWithParameters:inputDic];
        //创建HTTP连接管理对象
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //
        //    manager.responseSerializer = [AFHTTPResponse serializer];
        
        
        
        //GET 方法获取服务器的数据
        //GET 通过get方法
        //p1: 参数传入一个URL对象
        
        [manager GET:@"http://japi.juhe.cn/joke/content/list.from" parameters:inputDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"下载成功");
            
            //       NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            //       NSDictionary *a = (NSDictionary *)responseObject;
            NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *reason = nil;
            reason = [content objectForKey:@"reason"];
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
            resultDic = [content objectForKey:@"result"];
            NSMutableArray *dataArray = [NSMutableArray array];
            dataArray = [resultDic objectForKey:@"data"];
            NSMutableArray *contentArray = [NSMutableArray array];
            for (NSDictionary *one in dataArray) {
                
                [contentArray addObject:[one objectForKey:@"content"]];
            }
            
            
            dispatch_async(dispatch_get_main_queue(),^{
               
                if (delegate && [delegate respondsToSelector:@selector(getDataWithReson:dataList:)]){
                    
                    [delegate getDataWithReson:reason dataList:contentArray];
                }
                

            });
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError *_Nonnull error){
            NSLog(@"下载失败");
            NSLog(@"%@",error.domain);
            NSLog(@"testError__%ld",(long)error.code);
            NSLog(@"test______%@",error.localizedFailureReason);
        }];
    
    });
}

//weather
+ (void)queryJuheWeatherDataWithDelegate:(id<JuHeServiceDelegate>)delegate
                             cityName:(NSString *)cityName
                             dtype:(NSString *)dtype
                           appKey:(NSString *)appKey{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        NSMutableDictionary *inputDic = [NSMutableDictionary dictionary];
        
//        [inputDic setValue:[cityName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] forKey:@"cityname"];
        [inputDic setValue:cityName forKey:@"cityname"];
        
//        [inputDic setValue:@"%E6%B8%A9%E5%B7%9E" forKey:@"cityname"];
        [inputDic setValue:dtype forKey:@"dtype"];
        [inputDic setValue:appKey forKey:@"key"];
        
        //创建HTTP连接管理对象
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];

        
        [manager GET:@"http://op.juhe.cn/onebox/weather/query" parameters:inputDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"下载成功");
            NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *reason = nil;
            reason = [content objectForKey:@"reason"];
            
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
            resultDic = [content objectForKey:@"result"];
            
            NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
            dataDictionary = [resultDic objectForKey:@"data"];
            
            //realtime
            NSMutableDictionary *realTimeDictionary = [NSMutableDictionary dictionary];
            realTimeDictionary = [dataDictionary objectForKey:@"realtime"];
            
            realTime *rTime = [[realTime alloc] init];
            rTime.cityName = [realTimeDictionary objectForKey:@"city_name"];
            rTime.dateString = [realTimeDictionary objectForKey:@"date"];
            rTime.updateTime = [realTimeDictionary objectForKey:@"time"];
            rTime.week = [realTimeDictionary objectForKey:@"week"];
            rTime.moon = [realTimeDictionary objectForKey:@"moon"];
            
            NSDictionary *weather =[NSDictionary dictionary];
            weather = [realTimeDictionary objectForKey:@"weather"];
            rTime.temperature = [weather objectForKey:@"temperature"];
            rTime.humidity = [weather objectForKey:@"humidity"];
            rTime.generalInfo = [weather objectForKey:@"info"];
            
            //life
            Life *life = [[Life alloc] init];
            NSDictionary *lifeDictionary = [NSDictionary dictionary];
            lifeDictionary = [dataDictionary objectForKey:@"life"];
            
            NSDictionary *infoDictionary = [NSDictionary dictionary];
            infoDictionary = [lifeDictionary objectForKey:@"info"];
            
            life.chuanyi = [NSArray array];
            life.chuanyi = [infoDictionary objectForKey:@"chuanyi"];
            life.ganmao = [NSArray array];
            life.ganmao = [infoDictionary objectForKey:@"ganmao"];
            life.kongtiao = [NSArray array];
            life.kongtiao = [infoDictionary objectForKey:@"kongtiao"];
            life.wuran = [NSArray array];
            life.wuran = [infoDictionary objectForKey:@"wuran"];
            life.yudong = [NSArray array];
            life.yudong = [infoDictionary objectForKey:@"yundong"];
            
            //weatherFuture
            NSArray *weatherArray = [NSArray array];
            weatherArray = [dataDictionary objectForKey:@"weather"];
            
            //解析结果数组
            NSMutableArray *weatherFutureList = [NSMutableArray array];
           

            for (NSDictionary *one in weatherArray) {
                
                weatherFuture *wFuture = [[weatherFuture alloc] init];

                wFuture.dateString = [one objectForKey:@"date"];
                
                NSDictionary *infoDictionary = [NSDictionary dictionary];
                infoDictionary = [one objectForKey:@"info"];
                NSArray *dayArray = [NSArray array];
                dayArray = [infoDictionary objectForKey:@"day"];
                NSArray *nightArray = [NSArray array];
                nightArray = [infoDictionary objectForKey:@"night"];
                wFuture.dayTemperator = dayArray[2];
                wFuture.dayGeneralInfo = dayArray[1];
                wFuture.nightTemperator = nightArray[2];
                wFuture.nightGeneralInfo = nightArray[1];
                
                [weatherFutureList addObject:wFuture];
            }
            

            
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                if (delegate && [delegate respondsToSelector:@selector(getDataWithReson:realTime:life:weatherFutureList:)]){
                    
                    [delegate getDataWithReson:reason realTime:rTime life:life weatherFutureList:weatherFutureList];
                }
                
                
            });
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError *_Nonnull error){
            NSLog(@"下载失败");
            NSLog(@"%@",error.domain);
            NSLog(@"testError__%ld",(long)error.code);
            NSLog(@"test______%@",error.localizedFailureReason);
        }];
        
    });

    
}

//News
+ (void)queryJuheNewsDataWithDelegate:(id<JuHeServiceDelegate>)delegate
                               appkey:(NSString *)appKey
                                 type:(NSString *)type{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        NSMutableDictionary *inputDic = [NSMutableDictionary dictionary];
        [inputDic setValue:type forKey:@"type"];
        [inputDic setValue:appKey forKey:@"key"];
        
        //        [[JuHeService shareManager]aFGetDataWithParameters:inputDic];
        //创建HTTP连接管理对象
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //
        //    manager.responseSerializer = [AFHTTPResponse serializer];
        
        
        
        //GET 方法获取服务器的数据
        //GET 通过get方法
        //p1: 参数传入一个URL对象
        
        [manager GET:@"http://v.juhe.cn/toutiao/index" parameters:inputDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"下载成功");
            
            //       NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            //       NSDictionary *a = (NSDictionary *)responseObject;
            NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *reason = nil;
            reason = [content objectForKey:@"reason"];
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
            resultDic = [content objectForKey:@"result"];
            
            NSMutableArray *dataArray = [NSMutableArray array];
            dataArray = [resultDic objectForKey:@"data"];
            
            
            NSMutableArray *contentList = [NSMutableArray array];
            
            for (NSDictionary *one in dataArray) {
                
                NewObject *newsObject = [[NewObject alloc] init];

                newsObject.title = [one objectForKey:@"title"];
                newsObject.date = [one objectForKey:@"date"];
                newsObject.pictrueOneUrl = [one objectForKey:@"thumbnail_pic_s"];
                newsObject.pictrueTwoUrl = [one objectForKey:@"thumbnail_pic_s02"];
                newsObject.pictrueThreeUrl = [one objectForKey:@"thumbnail_pic_s03"];
                newsObject.newsUrl = [one objectForKey:@"url"];
                
                [contentList addObject:newsObject];
            }
            
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                if (delegate && [delegate respondsToSelector:@selector(getDataWithReason:newsObjectList:)]){
                    
                    [delegate getDataWithReason:reason newsObjectList:contentList];
                }
                
                
            });
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError *_Nonnull error){
            NSLog(@"下载失败");
            NSLog(@"%@",error.domain);
            NSLog(@"testError__%ld",(long)error.code);
            NSLog(@"test______%@",error.localizedFailureReason);
        }];
        
    });
}



+(JuHeService *)shareManager{
    static JuHeService *jhs = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        jhs = [[JuHeService alloc] init];
        
    });
    
    return jhs;
}

- (NSDictionary *)aFGetDataWithParameters:(NSDictionary *)parameters {
    
//    NSMutableDictionary *mutableParameters =  [NSMutableDictionary dictionaryWithDictionary:parameters];
    
//    _block NSMutableDictionary *dic;
    
//    dic = [NSMutableDictionary dictionary];

    
    //创建HTTP连接管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//    manager.responseSerializer = [AFHTTPResponse serializer];
    

    
    //GET 方法获取服务器的数据
    //GET 通过get方法
    //p1: 参数传入一个URL对象
    
   [manager GET:@"http://japi.juhe.cn/joke/content/list.from" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"下载成功");
       
       
       
//       NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//       NSDictionary *a = (NSDictionary *)responseObject;
       
       
       NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    
//       NSLog(@"请求成功：%@",content);
       
       NSLog(@"testDic_____%@",_dic);
//       NSLog(@"请求成功：%@",responseObject);
//       NSLog(@"%@",_dic);
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *_Nonnull error){
        NSLog(@"下载失败");
        NSLog(@"%@",error.domain);
        NSLog(@"testError__%ld",(long)error.code);
        NSLog(@"test______%@",error.localizedFailureReason);
    }];
    
    NSLog(@"dayin   %@",_dic);
    
    return _dic;
    
}

- (void) AFNetMonitor {
    
    //检查网络连接的状态
    //AFNetworkReachabilityManager 网络连接检测管理类
    //开启网络状态监控器
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //获取网络连接的是结果
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status)
        {
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"无网络连接");
                break;
            }
                

            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"通过wif连接的网络");
                break;
            }
            
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"通过移动网络，4G!");
                break;
            }
            
            default:
                break;
                
        }
        
    }];
}

- (void)a {
    //session
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manage = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:config];
    
    
}

@end

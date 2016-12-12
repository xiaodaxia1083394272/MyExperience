//
//  JuHeService.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/9/26.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "JuHeService.h"
#import "realTime.h"

//为了用哈希计算
#import <CommonCrypto/CommonDigest.h>


@interface JuHeService()


@end

@implementation JuHeService


#pragma mark - 创建请求者
+(AFHTTPSessionManager *)manager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 超时时间
    manager.requestSerializer.timeoutInterval = 30;
    
    // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    
    // 声明获取到的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
    // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
    return manager;
}


//Joke
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
        manager.requestSerializer.timeoutInterval = 5;
        
        //上传普通格式
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //上传Json格式
        // manager.responseSerializer = [AFJSONRequestSerializer serializer];
        
        // 声明获取到的数据格式
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
            manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
        // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
        
        //GET 方法获取服务器的数据
        //GET 通过get方法
        //p1: 参数传入一个URL对象
        


        
        [manager GET:@"http://japi.juhe.cn/joke/content/list.from" parameters:inputDic progress:^(NSProgress * _Nonnull downloadProgress){
            
            //这里可以获取到目前数据请求的进度
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"下载成功");
            
                 if (responseObject){
                     
                     NSLog(@"test __%@",responseObject);
                     
                     //          NSDictionary *content = (NSDictionary *)responseObject;
                     
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
                 } else {
                     
//                     success(@{@"msg":@"暂无数据"}, NO);
                     
                 }

            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError *_Nonnull error){
            NSLog(@"下载失败");
            NSLog(@"%@",error.domain);
            NSLog(@"testError__%ld",(long)error.code);
            NSLog(@"test______%@",error.localizedFailureReason);
            
//            // 请求失败
//            fail(error);
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
            //接口那货，变数据类型，所以我只好稍作保护
            if ([[dataDictionary objectForKey:@"life"] isKindOfClass:[NSDictionary class]]){
              
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
            }

            
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

/*使用下面方法需要导入 CommonCrypto/CommonDigest.h*/
//  哈希计算
+ (NSString *) sha1:(NSString *)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH *2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

#define AppSecret  @"JuERjS0W9n"
#define AppKey     @"uwd1c0sxdu5e1"


//IM
+ (void)queryIMTokenWithDelegate:(id<JuHeServiceDelegate>)delegate
                          userId:(NSString *)userId
                            name:(NSString *)name
                      completion:(void (^)(NSString * token)) completion {
    
                          
    //随机数,无长度限制
    NSString * nonce = [NSString stringWithFormat:@"%d",arc4random()];
    //    以1970/01/01 GMT为基准时间，返回实例保存的时间与1970/01/01 GMT的时间间隔
    NSDate *dateObc = [NSDate date];
    NSString *timestamp = [NSString stringWithFormat:@"%d",(int)[dateObc timeIntervalSince1970]];
    
    //        将系统分配的 AppSecret、Nonce (随机数)、Timestamp (时间戳)三个字符串按先后顺序拼接成一个字符串并进行 SHA1哈希计算
//    NSString *signature = [JuHeService  sha1:[NSString stringWithFormat:@"%@%@%@",AppSecret,nonce,timestamp]];//用sha1对签名进行加密,随你用什么方法,MD5...
    //POST 请求 请求参数放在请求内部（httpBody）
    //设置请求
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.cn.rong.io/user/getToken.json"]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:60];
    request.URL = [NSURL URLWithString:@"https://api.cn.rong.io/user/getToken.json"];
    //    [request setAllHTTPHeaderFields:nil];
    
    //配置http header
    [request setValue:AppKey forHTTPHeaderField:@"App-Key"];
    [request setValue:nonce forHTTPHeaderField:@"Nonce"];
    [request setValue:timestamp forHTTPHeaderField:@"Timestamp"];
    [request setValue:AppSecret forHTTPHeaderField:@"appSecret"];
    
   
    /*子类afnetworking做到这一步呢是这样的
     
     AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
     [sessionManager.requestSerializer setValue:AppKey forHTTPHeaderField:@"appkey"];
    都封装进manager里了，其他的还有比如
     _sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     _sessionManager.requestSerializer.timeoutInterval = 10;
     _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
     _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];等
     */
    //签名加密
    [request setValue:[JuHeService sha1:[NSString stringWithFormat:@"%@%@%@",AppSecret,nonce,timestamp]] forHTTPHeaderField:@"Signature"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //拼接参数
    NSMutableDictionary * paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:userId forKey:@"userId"];
    [paramDic setObject:name forKey:@"name"];
    [paramDic setObject:@"https://www.baidu.com/img/baidu_jgylogo3.gif" forKey:@"portraitUri"];
    
    request.HTTPBody = [JuHeService  httpBodyFromParamDictionary:paramDic];
    
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"45645dic:%@",content);
        
        NSString *token = [content objectForKey:@"token"];
       
        dispatch_async(dispatch_get_main_queue(),^{
            
            completion(token);
            
        });
        
    }];
    //5.执行任务
    [task resume];
}


//参数拼接
+ (NSData *)httpBodyFromParamDictionary:(NSDictionary *)param
{
    NSMutableString * data = [NSMutableString string];
    for (NSString * key in param.allKeys) {
        //其实关键是这一句，扩展有规定格式的字符串。
        [data appendFormat:@"%@=%@&",key,param[key]];
    }
    //
    return [[data substringToIndex:data.length-1] dataUsingEncoding:NSUTF8StringEncoding];
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

#pragma mark - download 

- (void)downLoadWithUrlString:(NSString *)urlString
{
    // 1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.设置请求的URL地址
    NSURL *url = [NSURL URLWithString:urlString];
    // 3.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 4.下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        // 下载进度
        NSLog(@"当前下载进度为:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 下载地址
        NSLog(@"默认下载地址%@",targetPath);
        // 设置下载路径,通过沙盒获取缓存地址,最后返回NSURL对象
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        return [NSURL fileURLWithPath:filePath]; // 返回的是文件存放在本地沙盒的地址
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // 下载完成调用的方法
        NSLog(@"%@---%@", response, filePath);
    }];
    // 5.启动下载任务
    [task resume];
}

#pragma mark - upLoad

- (void)uploadWithUser:(NSString *)userId UrlString:(NSString *)urlString upImg:(UIImage *)upImg
{
    // 创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 参数
    NSDictionary *param = @{@"user_id":userId};
    [manager POST:urlString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /******** 1.上传已经获取到的img *******/
        // 把图片转换成data
        NSData *data = UIImagePNGRepresentation(upImg);
        // 拼接数据到请求题中
        [formData appendPartWithFileData:data name:@"file" fileName:@"123.png" mimeType:@"image/png"];
        /******** 2.通过路径上传沙盒或系统相册里的图片 *****/
        //        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"文件地址"] name:@"file" fileName:@"1234.png" mimeType:@"application/octet-stream" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 打印上传进度
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        NSLog(@"请求成功：%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        NSLog(@"请求失败：%@",error);
    }];
}

#pragma mark - 网络监听

- (void)AFNetworkStatus{
    
    //1.创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络状态");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据网");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                
                break;
                
            default:
                break;
        }
        
    }] ;
}

@end

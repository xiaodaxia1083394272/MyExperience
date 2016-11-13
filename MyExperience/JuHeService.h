//
//  JuHeService.h
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/9/26.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "realTime.h"
#import "Life.h"
#import "weatherFuture.h"
#import "PAndM.h"
#import "NewObject.h"


@protocol JuHeServiceDelegate <NSObject>

@optional
- (void)getDataWithReson:(NSString *)reason
                dataList:(NSArray *)dataList;

- (void)getDataWithReson:(NSString *)reason
                realTime:(realTime *)realTime
                    life:(Life *)life
       weatherFutureList:(NSArray *)weatherFutureList;

- (void)getDataWithReason:(NSString *)reason
           newsObjectList:(NSMutableArray *)newsObjectList;

@end


@interface JuHeService : NSObject

//@property (assign,nonatomic) id<JuHeServiceDelegate> delegate;
@property (strong, nonatomic) NSMutableDictionary *dic;

+ (void)queryJuheDataWithDelegate:(id<JuHeServiceDelegate>)delegate
                             Sort:(NSString *)sort
                         page:(int)page
                     pageSize:(int)pageSize
                         time:(NSDate *)queryTime
                       appKey:(NSString *)appKey;

+ (void)queryJuheWeatherDataWithDelegate:(id<JuHeServiceDelegate>)delegate
                                cityName:(NSString *)cityName
                                   dtype:(NSString *)dtype
                                  appKey:(NSString *)appKey;

+ (void)queryJuheNewsDataWithDelegate:(id<JuHeServiceDelegate>)delegate
                               appkey:(NSString *)appKey
                                 type:(NSString *)type;

+ (void)queryIMTokenWithDelegate:(id<JuHeServiceDelegate>)delegate
                          userId:(NSString *)userId
                            name:(NSString *)name
                      completion:(void (^)(NSString * token)) completion;
@end

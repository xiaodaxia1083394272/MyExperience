//
//  WeatherObject.h
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/12.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "realTime.h"
#import "Life.h"
#import "weatherFuture.h"
#import "PAndM.h"

@interface WeatherObject : NSObject
@property (strong, nonatomic) realTime *realTime;//当前
@property (strong, nonatomic) Life *life;//生活指数
@property (strong, nonatomic) NSArray *weatherFutureList; //未来几天天气预报
@property (strong, nonatomic) PAndM *pAndM;

@end

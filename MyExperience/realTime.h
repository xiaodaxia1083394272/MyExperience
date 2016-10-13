//
//  realTime.h
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/12.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface realTime : NSObject

@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString *dateString;
@property (copy, nonatomic) NSString *updateTime;
@property (copy, nonatomic) NSString *week;
@property (copy, nonatomic) NSString *moon;
@property (copy, nonatomic) NSString *temperature;
@property (copy, nonatomic) NSString *humidity;
@property (copy, nonatomic) NSString *generalInfo;

@end

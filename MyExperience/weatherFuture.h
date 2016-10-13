//
//  weatherFuture.h
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/12.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface weatherFuture : NSObject

@property (copy, nonatomic) NSString *dateString;
@property (copy, nonatomic) NSString *dayTemperator;
@property (copy, nonatomic) NSString *dayGeneralInfo;
@property (copy, nonatomic) NSString *nightTemperator;
@property (copy, nonatomic) NSString *nightGeneralInfo;

@end

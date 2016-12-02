//
//  IMUser.h
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/11/19.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 我们要做的就是将Student类型变成NSData类型 ，那么就必须实现归档：
 
 这里要实现 在.h 文件中申明 NSCoding 协议，再 在 .m 中实现 encodeWithCoder 方法 和
 
 initWithCoder 方法就可以了
 */

@interface IMUser : NSObject<NSCoding>
@property (copy, nonatomic) NSString *imUserId;
@property (copy, nonatomic) NSString *imUserName;
@property (copy, nonatomic) NSString *imUserToken;
@property (assign, nonatomic) BOOL imIsSave;

@end

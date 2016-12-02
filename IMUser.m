//
//  IMUser.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/11/19.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "IMUser.h"

@implementation IMUser

//这样做就可以将自定义类型转变为NSData类型了
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.imUserId forKey:@"imUserId"];
    [aCoder encodeObject:self.imUserName forKey:@"imUserName"];
    [aCoder encodeObject:self.imUserToken forKey:@"imUserToken"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.imIsSave] forKey:@"imIsSave"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if(self =[super init]){
        self.imUserId = [aDecoder decodeObjectForKey:@"imUserId"];
        self.imUserName = [aDecoder decodeObjectForKey:@"imUserName"];
        self.imUserToken = [aDecoder decodeObjectForKey:@"imUserToken"];
        
        //这个貌似不能直接存基本数据类型，要统一转成NSNumber 对象
        self.imIsSave = [[aDecoder decodeObjectForKey:@"imIsSave"] boolValue];

    }
    return self;
}


@end

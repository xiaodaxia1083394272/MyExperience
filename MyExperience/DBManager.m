//
//  DBManager.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/9/9.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "DBManager.h"

#define kDatabaseName @"myDatabase.db"

@implementation DBManager

-(instancetype)init{
    
    DBManager *manager;
    
    if((manager=[super init]))
        
    {
        
        [manager openDbWithTicket:kDatabaseName];
        
    }
    
    return manager;
    
}

-(void)openDbWithTicket:(NSString *)myTrainName{
    

    //取得数据库保存路径，通常保存沙盒Documents目录
    
    NSString *directory=[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject];
    
    NSLog(@"%@",directory);
    
    NSString *filePath=[directory stringByAppendingPathComponent:myTrainName];
    
    //如果有数据库则直接打开，否则创建并打开（注意filePath是ObjC中的字符串，需要转化为C语言字符串类型）
    
    if (SQLITE_OK ==sqlite3_open(filePath.UTF8String, &_workPeople)) {
        
        NSLog(@"数据库打开成功!");
        
    }else{
        
        NSLog(@"数据库打开失败!");
        
    }
    
}

-(void)askWorkPeopleToDoSomeThing:(NSString *)myRequest{
    char *error;
    
    //单步执行sql语句，用于插入、修改、删除
    
    if (SQLITE_OK!=sqlite3_exec(_workPeople, myRequest.UTF8String, NULL, NULL,&error)) {
        
        NSLog(@"执行SQL语句过程中发生错误！错误信息：%s",error);
        
    }
}



-(NSArray *)askWorkPeopleToDoSomeThingAndGetAnswer:(NSString *)myRequest{
    NSMutableArray *rows=[NSMutableArray array];//数据行
    
    
    
    //评估语法正确性
    
    sqlite3_stmt *stmt;
    
    //检查语法正确性
    
    if (SQLITE_OK==sqlite3_prepare_v2(_workPeople, myRequest.UTF8String, -1, &stmt, NULL)) {
        
        //单步执行sql语句
        
        while (SQLITE_ROW==sqlite3_step(stmt)) {
            
            int columnCount= sqlite3_column_count(stmt);
            
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            
            for (int i=0; i<columnCount; i++) {
                
                const char *name= sqlite3_column_name(stmt, i);//取得列名
                
                const unsigned char *value= sqlite3_column_text(stmt, i);//取得某列的值
                
                dic[[NSString stringWithUTF8String:name]]=[NSString stringWithUTF8String:(const char *)value];
                
            }
            
            [rows addObject:dic];
            
        }
        
    }
    
    
    
    //释放句柄
    
    sqlite3_finalize(stmt);
    
    
    
    return rows;
    
}


@end

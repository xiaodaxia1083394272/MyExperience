//
//  SQLManager.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/9/20.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "SQLManager.h"

@implementation SQLManager

#define kNameFile (@"Student.sqlite")
//单例
+ (SQLManager *)shareManager{
   
    static SQLManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        
        manager = [[self alloc] init];
        [manager createDataBaseTableIfNeeded];
    });
    
    return manager;
    
}
//拼接路径
- (NSString *)applicationDocumentDirectoryFile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    NSString *filePath = [documentDirectory stringByAppendingString:kNameFile];
    return filePath;
}

//创表
- (void)createDataBaseTableIfNeeded {
    
    NSString *writetablePath = [self applicationDocumentDirectoryFile];
    NSLog(@"数据库的地址: %@",writetablePath);
    //路径
//    对象
    if (sqlite3_open([writetablePath UTF8String],&_db) != SQLITE_OK) {
        
        sqlite3_close(_db);
        NSAssert(NO,@"数据库打开失败");
        
    }else {
        
        char *err;
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS StudentName (idNum TEXT PRIMARY KEY, name TEXT);"];
        if (sqlite3_exec(_db,[createSQL UTF8String],NULL,NULL,&err) != SQLITE_OK){
         
            sqlite3_close(_db);
            NSAssert(NO,@"建表失败");
            
        }
        sqlite3_close(_db);
        
    }
    
}

//查询
- (StudentModel *)searchWithIdNum:(StudentModel *)model{
    NSString *path = [self applicationDocumentDirectoryFile];
    if (sqlite3_open([path UTF8String],&_db) != SQLITE_OK) {
        sqlite3_close(_db);
//        NSAssert(NO,@"建表失败");
    }else {
        
        NSString *qsql = @"SELECT idNum,name FROM StudentName where idNum = ?";
        sqlite3_stmt *statement; //语句对象
        
        if (sqlite3_prepare_v2(_db,[qsql UTF8String],-1,&statement,NULL) == SQLITE_OK){
           
            //进行，按主键查询数据库
            NSString *idNum = model.idNum;
            sqlite3_bind_text(statement,1,[idNum UTF8String],-1,NULL);
            
            //遍历
            if (sqlite3_step(statement)== SQLITE_ROW){
//                提取数据
                char *idNum = (char *)sqlite3_column_text(statement,0);
                NSString *idNumStr = [[NSString alloc] initWithUTF8String:idNum];
                char *name = (char *)sqlite3_column_text(statement,1);
                NSString *nameStr = [[NSString alloc] initWithUTF8String:name];
                StudentModel *model = [[StudentModel alloc] init];
                model.idNum = idNumStr;
                model.name = nameStr;
                
                sqlite3_finalize(statement);
                sqlite3_close(_db);
           
                return model;
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_db);
    }
    return nil;
}
//修改数据库
- (int)insert:(StudentModel *)model{
    
    NSString *path = [self applicationDocumentDirectoryFile];
    if (sqlite3_open([path UTF8String],&_db) != SQLITE_OK) {
        sqlite3_close(_db);
        //        NSAssert(NO,@"建表失败");
    }else {
        
        NSString *sql = @"INSERT OR REPLACE INTO StudentName (idNum,name) VALUES(?,?)";
        sqlite3_stmt *statement; //语句对象
        //预处理过程
        if (sqlite3_prepare_v2(_db,[sql UTF8String],-1,&statement,NULL) == SQLITE_OK){

            sqlite3_bind_text(statement,1,[model.idNum UTF8String],-1,NULL);
            sqlite3_bind_text(statement,2,[model.name UTF8String],-1,NULL);
            
            //遍历
            if (sqlite3_step(statement)!= SQLITE_ROW){

                sqlite3_close(_db);
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_db);
    }
    
    return 0;
}
@end

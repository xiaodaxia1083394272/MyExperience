//
//  SQLManager.h
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/9/20.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "StudentModel.h"


@interface SQLManager : NSObject
@property (nonatomic, assign) sqlite3 *db;

+ (SQLManager *)shareManager;

- (StudentModel *)searchWithIdNum:(StudentModel *)model;

- (int)insert:(StudentModel *)model;
@end

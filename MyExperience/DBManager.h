//
//  DBManager.h
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/9/9.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DBManager : NSObject

@property (nonatomic) sqlite3 *workPeople;

-(void)openDbWithTicket:(NSString *)myTrainName;
-(void)askWorkPeopleToDoSomeThing:(NSString *)myRequest;
-(NSArray *)askWorkPeopleToDoSomeThingAndGetAnswer:(NSString *)myRequest;

@end

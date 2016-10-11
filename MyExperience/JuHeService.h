//
//  JuHeService.h
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/9/26.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol JuHeServiceDelegate <NSObject>

- (void)getDataWithReson:(NSString *)reason
                dataList:(NSArray *)dataList;

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
@end

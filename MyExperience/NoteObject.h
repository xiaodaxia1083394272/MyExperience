//
//  NoteObject.h
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/14.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteObject : NSObject

@property (assign, nonatomic) NSInteger dataID;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@end

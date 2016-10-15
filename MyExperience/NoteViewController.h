//
//  NoteViewController.h
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/10.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoteObject;

@interface NoteViewController : UIViewController
@property (assign, nonatomic) BOOL isShowHistoryObject;

- (instancetype)initWithHistoryObject:(NoteObject *)historyObject isShowHistoryObject:(BOOL)isShowHistoryObject;

@end

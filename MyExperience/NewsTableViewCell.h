//
//  JokeTableViewCell.h
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/11.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewObject.h"

@interface NewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


+ (id)createCell;
- (void)updateCellWithNewObject:(NewObject *)newsObject;
@end

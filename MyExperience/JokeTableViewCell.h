//
//  JokeTableViewCell.h
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/11.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JokeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jokeLabel;

+ (id)createCell;
- (void)updateCellWithJokeString:(NSString *)jokeString indexPath:(NSIndexPath *)indexPath;
@end

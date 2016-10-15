//
//  JokeTableViewCell.h
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/11.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewObject.h"
#import "NoteObject.h"

@interface NewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageAndTitleWidthConstraint;


+ (id)createCell;
- (void)updateCellWithNewObject:(NewObject *)newsObject;
- (void)updateCellWithNoteObject:(NoteObject *)noteObject;

@end

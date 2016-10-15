//
//  JokeTableViewCell.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/11.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "NewsTableViewCell.h"


@implementation NewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (id)createCell
{
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:self options:nil];
    
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        //  NSLog(@"create %@ but cannot find cell object from Nib", cellId);
        return nil;
    }
    NewsTableViewCell *cell = [topLevelObjects objectAtIndex:0];
    
    //workaround for IOS 7 auto layout bug
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1)
    {
        cell.contentView.bounds = CGRectMake(0, 0, 99999, 99999);
    }
    
    //图片变圆
    cell.titleImage.layer.cornerRadius = 22.5;
    cell.titleImage.layer.masksToBounds = YES;
    [cell.titleImage setContentMode:UIViewContentModeScaleAspectFill];
    
    return cell;
}

- (void)updateCellWithNewObject:(NewObject *)newsObject{

    self.contentLabel.text = newsObject.title;
}

- (void)updateCellWithNoteObject:(NoteObject *)noteObject{
    
    self.contentLabel.text = noteObject.title;


}
@end

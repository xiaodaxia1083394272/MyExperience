//
//  JokeTableViewCell.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/10/11.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "JokeTableViewCell.h"

@implementation JokeTableViewCell

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
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"JokeTableViewCell" owner:self options:nil];
    
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        //  NSLog(@"create %@ but cannot find cell object from Nib", cellId);
        return nil;
    }
    JokeTableViewCell *cell = [topLevelObjects objectAtIndex:0];
    
    //workaround for IOS 7 auto layout bug
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1)
    {
        cell.contentView.bounds = CGRectMake(0, 0, 99999, 99999);
    }
    
    return cell;
}

- (void)updateCellWithJokeString:(NSString *)jokeString indexPath:(NSIndexPath *)indexPath{
    
    self.jokeLabel.text = jokeString;
    
}


@end

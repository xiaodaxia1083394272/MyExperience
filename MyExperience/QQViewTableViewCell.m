//
//  QQViewTableViewCell.m
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/9/11.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "QQViewTableViewCell.h"

@implementation QQViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)getCellIdentifier
{
    return @"QQViewTableViewCell";
}


+ (id)createCell
{
    NSString *cellId = [self getCellIdentifier];
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
    
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        //  NSLog(@"create %@ but cannot find cell object from Nib", cellId);
        return nil;
    }
    QQViewTableViewCell *cell = [topLevelObjects objectAtIndex:0];
    
    //workaround for IOS 7 auto layout bug
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1)
    {
        cell.contentView.bounds = CGRectMake(0, 0, 99999, 99999);
    }

    return cell;
}

@end

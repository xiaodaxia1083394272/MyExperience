//
//  CourtJoinDateListView.h
//  Sport
//
//  Created by xiaoyang on 16/6/13.
//  Copyright © 2016年 haodong . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "weatherFuture.h"

@protocol WeatherDateViewDelegate <NSObject>
@optional
- (void)didClickWeatherDateView:(NSString *)dateString;
@end


@interface WeatherDateView : UIView
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *temperatorLabel;

@property (strong, nonatomic) NSString *dateString;
@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) id<WeatherDateViewDelegate > delegate;

+(WeatherDateView *)createWeatherDateViewWithHoldViewWidth:(CGFloat)holdViewWidth;

- (void)updatView:(weatherFuture *)wf
       isSelected:(BOOL)isSelected
            index:(int)index;

+ (CGSize)defaultSize;

- (void)updateSelected:(BOOL)isSelected;


@end

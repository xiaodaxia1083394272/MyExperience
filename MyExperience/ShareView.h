//
//  ShareView.h
//  MyExperience
//
//  Created by qiuhaodong_macmini on 16/9/23.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    ShareChannelWeChatSession,
    ShareChannelWeChatTimeline,
    ShareChannelSina,
    ShareChannelCopy ,
    ShareChannelSMS ,
    ShareChannelQQ ,
    ShareChannelQQZone ,
    
}ShareChannel;

@interface ShareView : UIView

@end

//
//  MENetworkResponse.h
//  MyExperience
//
//  Created by HMRL on 16/12/2.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MENetworkResponse : NSObject
@property (readonly, nonatomic, strong) NSDictionary *jsonResult;
@property (readonly, nonatomic, strong) NSURLResponse *response;

- (instancetype)initWithJsonResult:(NSDictionary *)jsonResult
                          response:(NSURLResponse *)response;
@end

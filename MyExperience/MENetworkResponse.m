//
//  MENetworkResponse.m
//  MyExperience
//
//  Created by HMRL on 16/12/2.
//  Copyright © 2016年 qiuhaodong_macmini. All rights reserved.
//

#import "MENetworkResponse.h"
@interface MENetworkResponse()

@property (readwrite, nonatomic, strong) NSDictionary *jsonResult;
@property (readwrite, nonatomic, strong) NSURLResponse *response;

@end


@implementation MENetworkResponse

- (instancetype)initWithJsonResult:(NSDictionary *)jsonResult
                          response:(NSURLResponse *)response
{
    self = [super init];
    if (self) {
        self.jsonResult = jsonResult;
        self.response = response;
    }
    return self;
}

@end

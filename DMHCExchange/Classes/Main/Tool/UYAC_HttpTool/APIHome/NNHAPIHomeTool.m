//
//  NNHAPIHomeTool.m
//  SuperWallet
//
//  Created by 来旭磊 on 2018/8/21.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNHAPIHomeTool.h"

@implementation NNHAPIHomeTool

- (instancetype)initWithHomeData {
    if (self = [super init]) {
        self.requestReServiceType = @"index.index.index";
        self.reAPIName = @"获取首页数据";
    }
    return self;
}

- (instancetype)initWithNewsList {
    if (self = [super  init]) {
        self.requestReServiceType = @"index.index.newslist";
        self.reAPIName = @"获取首页资讯列表";
    }
    return self;
}

-(instancetype)initWithMarketCoinID:(NSString *)coinID
                             period:(NSString *)period {
    
    if (self = [super init]) {
        self.requestReServiceType = @"coin.kline.kline";
        self.reParams = @{
                          @"marketcoinid":coinID,
                          @"period":period
                          };
        self.reAPIName = @"获取k线图数据";
    }
    return self;
}

@end

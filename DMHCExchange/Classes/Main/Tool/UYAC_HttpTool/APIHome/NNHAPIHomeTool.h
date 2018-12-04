//
//  NNHAPIHomeTool.h
//  SuperWallet
//
//  Created by 来旭磊 on 2018/8/21.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNHBaseRequest.h"

@interface NNHAPIHomeTool : NNHBaseRequest



/**
获取首页数据

 @return NNHAPIHomeTool instance
 */
-(instancetype)initWithHomeData;



/**
 获取首页二级页面资讯列表

 @return NNHAPIHomeTool instance
 */
- (instancetype)initWithNewsList;


/**
 获取首页二级页面k线图数据

 @param coinID 币种id
 @param period K线时间断
 @return NNHAPIHomeTool instance
 */
- (instancetype)initWithMarketCoinID:(NSString *)coinID
                              period:(NSString *)period;


@end

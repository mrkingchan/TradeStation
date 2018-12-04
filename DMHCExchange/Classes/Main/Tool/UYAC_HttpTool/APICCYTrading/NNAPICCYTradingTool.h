//
//  NNAPICCYTradingTool.h
//  SuperWallet
//
//  Created by 牛牛 on 2018/9/12.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNHBaseRequest.h"

@interface NNAPICCYTradingTool : NNHBaseRequest

/**
 获取交易品种
 
 @return api接口
 */
- (instancetype)initCCYTradingSymbol;

/**
 获取CCY交易列表
 
 @return api接口
 */
- (instancetype)initCCYTradingListWithSymbol:(NSString *)symbol
                                        type:(NNHCoinTradingOrderType)type;

@end

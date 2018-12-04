//
//  NNAPICCYTradingTool.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/9/12.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNAPICCYTradingTool.h"

@implementation NNAPICCYTradingTool

/**
 获取交易品种
 
 @return api接口
 */
- (instancetype)initCCYTradingSymbol
{
    if (self = [super init]) {
        
    }
    return self;
}

/**
 获取CCY交易列表
 
 @return api接口
 */
- (instancetype)initCCYTradingListWithSymbol:(NSString *)symbol
                                        type:(NNHCoinTradingOrderType)type
{
    if (self = [super init]) {
        
    }
    return self;
}

@end

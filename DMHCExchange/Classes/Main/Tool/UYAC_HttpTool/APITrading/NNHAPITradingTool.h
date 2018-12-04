//
//  NNHAPITradingTool.h
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/27.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           交易模块 相关api接口
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import "NNHBaseRequest.h"

@interface NNHAPITradingTool : NNHBaseRequest

/**
 获取交易对
 
 @return api接口
 */
- (instancetype)initMarketSymbol;


/**
 获取行情首页 数据列表

 @return api接口
 */
- (instancetype)initCoinTradingMarketWithCCY:(NSString *)ccy;


/**
 单个行情接口
 
 @return api接口
 */
- (instancetype)initSingleCoinTradingDataSourceWithCoinID:(NSString *)coinID;


/**
 币种介绍
 
 @return api接口
 */
- (instancetype)initCoinIntroduceWithCoinID:(NSString *)coinID;


/**
 当前交易币种最新价格
 
 @return api接口
 */
- (instancetype)initTradingCoinNewPriceWithCoinID:(NSString *)coinID;


/**
 用户市场余额 挂单用
 
 @return api接口
 */
- (instancetype)initTradingUserBalanceWithCoinID:(NSString *)coinID;


/**
 币种交易下单

 @param orderType 挂单类型买进 卖出  1 买 2 卖
 @param coinName 交易币种 EOS/BTC
 @param paypwd 密码
 @param amount 总量
 @param price 金额
 @return api接口
 */
- (instancetype)initCoinOrderWithOrderType:(NNHCoinTradingOrderType)orderType
                                    paypwd:(NSString *)paypwd
                                  coinName:(NSString *)coinName
                                    amount:(NSString *)amount
                                     price:(NSString *)price;

/**
 当前挂单列表
 @param coinID 组合id
 @return api接口
 */
- (instancetype)initTradingBuySellListWithWithCoinID:(NSString *)coinID;


/**
 用户当前委托挂单列表
 @param coinID 交易对id
 @return api接口
 */
- (instancetype)initCurrentEntrustListWithCoinID:(NSString *)coinID;


/**
 用户历史订单列表 已成交
 @param coinID 交易对id
 @return api接口
 */
- (instancetype)initHistoryEntrustListWithWithCoinID:(NSString *)coinID
                                                page:(NSUInteger)page;

/**
 k线接口
 
 @param coin 币种
 @param period 分时类型 1m,5m,15m,30m,1h,2h,4h,1d
 @param ccy 计价货币[CNY,USD]
 @param ctime 起始时间，读取此时间之前的数据，默认当前时间
 @param num 读取数量，默认60
 @return api接口
 */
- (instancetype)initCoinChartWithCoin:(NSString *)coin
                               period:(NSString *)period
                                  ccy:(NSString *)ccy
                                ctime:(NSString *)ctime
                                  num:(NSUInteger)num;


/**
 用户撤单

 @param orderno 订单编号
 @return api接口
 */
- (instancetype)initCancelOrderWithOrderno:(NSString *)orderno;


/**
 币搜索
 
 @param ccyID 币ID
 @param keyword 关键词
 @return api接口
 */
- (instancetype)initCoinSearchWithCCYID:(NSString *)ccyID
                                keyword:(NSString *)keyword;

@end

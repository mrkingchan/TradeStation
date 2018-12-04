//
//  NNLegalTenderTradeReleaseCoinModel.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/30.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易  发布订单前 币种模型
 
 @Remarks          vc
 
 *****************************************************/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeReleaseCoinModel : NSObject

/** 注释 */
@property (nonatomic, copy) NSString *amount;

/** 当前价格 */
@property (nonatomic, copy) NSString *currentPrice;

/** 买入手续费 */
@property (nonatomic, copy) NSString *fee_buy;

/** 卖出手续费 */
@property (nonatomic, copy) NSString *fee_sell;

/** 卖出手续费说明 */
@property (nonatomic, copy) NSString *fee_sell_str;

/** 买入手续费说明 */
@property (nonatomic, copy) NSString *fee_buy_str;

/** 法币名称 */
@property (nonatomic, copy) NSString *coinname;

/** 交易保证金 */
@property (nonatomic, copy) NSString *sell_bail;

/** 交易保证金说明 */
@property (nonatomic, copy) NSString *sell_bail_str;

/** 交易保证金 */
@property (nonatomic, copy) NSString *buy_bail;

/** 交易保证金说明 */
@property (nonatomic, copy) NSString *buy_bail_str;

/** 数量小数点后位数 */
@property (nonatomic, copy) NSString *round;

/** 最小交易限额 */
@property (nonatomic, strong) NSString *minmum;

/** 最大交易限额 */
@property (nonatomic, strong) NSString *trade_max_amount;


@end

NS_ASSUME_NONNULL_END

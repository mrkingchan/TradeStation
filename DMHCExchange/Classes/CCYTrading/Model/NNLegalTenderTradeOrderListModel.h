//
//  NNLegalTenderTradeOrderListModel.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/30.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易  已撮合订单 交易记录 列表数据
 
 @Remarks          vc
 
 *****************************************************/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeOrderListModel : NSObject

/** 订单id */
@property (nonatomic, copy) NSString *orderID;

/** 用户id */
@property (nonatomic, copy) NSString *userid;

/** 挂单价格 */
@property (nonatomic, copy) NSString *price;

/** 法币名称 */
@property (nonatomic, copy) NSString *coinname;

/** 订单号 */
@property (nonatomic, copy) NSString *orderno;

/** 添加时间 */
@property (nonatomic, copy) NSString *buytime;

/** 交易类型(1为买入 2为卖出) */
@property (nonatomic, copy) NSString *type;

/** 订单状态 */
@property (nonatomic, copy) NSString *status;

/** 已成交数量 */
@property (nonatomic, copy) NSString *num;

/** 总金额 */
@property (nonatomic, copy) NSString *mum;

/**  按钮文字 */
@property (nonatomic, copy) NSString *actstr;

/** 订单状态说明 */
@property (nonatomic, copy) NSString *statusstr;

@end

NS_ASSUME_NONNULL_END

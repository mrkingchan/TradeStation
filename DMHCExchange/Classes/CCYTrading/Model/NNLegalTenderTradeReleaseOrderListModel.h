//
//  NNLegalTenderTradeReleaseOrderListModel.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/30.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易  已发布的交易单页面 列表数据
 
 @Remarks          vc
 
 *****************************************************/

#import "NNHBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeReleaseOrderListActionModel : NSObject
/** 操作 */
@property (nonatomic, copy) NSString *actstr;
/** 状态 */
@property (nonatomic, copy) NSString *statusstr;
@end

@interface NNLegalTenderTradeReleaseOrderListModel : NNHBaseRequest

/** 订单id */
@property (nonatomic, copy) NSString *tradeid;

/** 用户id */
@property (nonatomic, copy) NSString *userid;

/** 挂单价格 */
@property (nonatomic, copy) NSString *price;

/** 法币名称 */
@property (nonatomic, copy) NSString *coinname;

/** 订单号 */
@property (nonatomic, copy) NSString *orderno;

/** 添加时间 */
@property (nonatomic, copy) NSString *addtime;

/** 交易类型(1为买入 2为卖出) */
@property (nonatomic, copy) NSString *type;

/** 订单状态 */
@property (nonatomic, copy) NSString *status;

/** 已成交数量 */
@property (nonatomic, copy) NSString *dealnum;

/** 委托数量 */
@property (nonatomic, copy) NSString *totalnum;

/** 订单状态 */
@property (nonatomic, copy) NSString *statusString;

/** 状态操作 */
@property (nonatomic, strong) NNLegalTenderTradeReleaseOrderListActionModel *tradeact;

@end

NS_ASSUME_NONNULL_END

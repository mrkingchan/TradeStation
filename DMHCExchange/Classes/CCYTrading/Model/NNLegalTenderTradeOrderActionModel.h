//
//  NNLegalTenderTradeOrderActionModel.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/30.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeOrderActionModel : NSObject

/** 订单id */
@property (nonatomic, strong) NSString *orderID;
/** 昵称 */
@property (nonatomic, copy) NSString *realname;
/** 币种名称 */
@property (nonatomic, copy) NSString *coinname;
/** 可用余额 */
@property (nonatomic, copy) NSString *coinamount;
/** 冻结余额 */
@property (nonatomic, copy) NSString *fut_coinamount;
/** 最小限额 */
@property (nonatomic, copy) NSString *minmum;
/** 最大金额 */
@property (nonatomic, copy) NSString *maxmum;
/** 已成交数量 */
@property (nonatomic, copy) NSString *num;
/** 价格 */
@property (nonatomic, copy) NSString *price;
/** 数量 */
@property (nonatomic, copy) NSString *totalnum;
/** 支付宝 */
@property (nonatomic, copy) NSString *isalipay;
/** 微信 */
@property (nonatomic, copy) NSString *iswechat;
/** 银行卡 */
@property (nonatomic, copy) NSString *isbank;
/** 总金额 */
@property (nonatomic, copy) NSString *addtime;
/** 备注 */
@property (nonatomic, copy) NSString *remarks;
/** 成交率 */
@property (nonatomic, copy) NSString *deal;
/** 1为买单 2为卖单 */
@property (nonatomic, copy) NSString *type;
/** 已成交单数 */
@property (nonatomic, copy) NSString *dealnum;
/** 价格小数点位数 */
@property (nonatomic, copy) NSString *round;
/** 支付方式数组 */
@property (nonatomic, strong) NSMutableArray *iconNameArray;

@end

NS_ASSUME_NONNULL_END

//
//  NNTradingEntrustModel.h
//  SuperWallet
//
//  Created by 牛牛 on 2018/4/1.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNTradingLogModel : NSObject

/** ID */
@property (nonatomic, copy) NSString *logID;
/** 品种 */
@property (nonatomic, copy) NSString *coinname;
/** 支付货币 */
@property (nonatomic, copy) NSString *unitcoinname;
/** 买/卖 */
@property (nonatomic, copy) NSString *type;
/** 成交时间 */
@property (nonatomic, copy) NSString *matchtime;
/** 成交量 */
@property (nonatomic, copy) NSString *num;
/** 价格 */
@property (nonatomic, copy) NSString *price;
/** 手续费 */
@property (nonatomic, copy) NSString *fee;

@end

@interface NNTradingEntrustModel : NSObject

/** 委托单ID */
@property (nonatomic, copy) NSString *ID;
/** 订单号 */
@property (nonatomic, copy) NSString *orderno;
/** 交易对名字 */
@property (nonatomic, copy) NSString *name;
/** 交易币 */
@property (nonatomic, copy) NSString *coinname;
/** 交易货币 */
@property (nonatomic, strong) NSString *unitcoinname;
/** 1买单2卖单 */
@property (nonatomic, copy) NSString *type;
/** 状态 0 未成交 1 部分成交 2 全部成交 3 已取消 */
@property (nonatomic, copy) NSString *status;
/** 时间 */
@property (nonatomic, copy) NSString *addtime;
/** 挂单量 */
@property (nonatomic, copy) NSString *totalnum;
/** 已成交量 */
@property (nonatomic, copy) NSString *num;
/** 挂单价 */
@property (nonatomic, copy) NSString *price;
/** 成交均价 */
@property (nonatomic, copy) NSString *averages;
/** 成交总额 */
@property (nonatomic, copy) NSString *unitnum;
/** 成交日志 */
@property (nonatomic, strong) NSMutableArray <NNTradingLogModel *> *logs;

// 辅助属性
@property (nonatomic, copy) NSString *statusText;

@end

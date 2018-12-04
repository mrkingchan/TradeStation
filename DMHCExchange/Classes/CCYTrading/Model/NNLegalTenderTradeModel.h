//
//  NNCCYTradingModel.h
//  SuperWallet
//
//  Created by 牛牛 on 2018/9/12.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNLegalTenderTradeModel : NSObject

/** 订单id */
@property (nonatomic, strong) NSString *orderID;
/** 商家 */
@property (nonatomic, copy) NSString *userid;
/** 市场 */
@property (nonatomic, copy) NSString *price;
/** 成交量 */
@property (nonatomic, copy) NSString *num;
/** 成交比例 */
@property (nonatomic, copy) NSString *minmum;
/** 成交比例 */
@property (nonatomic, copy) NSString *mum;
/** 订单总额 */
@property (nonatomic, copy) NSString *amount;
/** 限额 */
@property (nonatomic, copy) NSString *isalipay;
/** 限额 */
@property (nonatomic, copy) NSString *iswechat;
/** 数量 */
@property (nonatomic, copy) NSString *isbank;
/** 时间 */
@property (nonatomic, copy) NSString *credit;
/** 总金额 */
@property (nonatomic, copy) NSString *addtime;
/** 用户昵称 */
@property (nonatomic, copy) NSString *nickname;
/** 已成交单数 */
@property (nonatomic, copy) NSString *clinch_num;
/** 完成率 */
@property (nonatomic, copy) NSString *UserRules;
/** 订单类型 1买单 2卖单 */
@property (nonatomic, strong) NSString *type;

/** 支付方式数组 */
@property (nonatomic, strong) NSMutableArray *iconNameArray;

@end

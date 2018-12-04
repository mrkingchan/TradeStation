//
//  NNCoinTradingMarketModel.h
//  SuperWallet
//
//  Created by 牛牛 on 2018/8/13.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNCoinTradingMarketModel : NSObject

/** 交易对ID */
@property (nonatomic, copy) NSString *marketcoinid;
/** 交易币ID */
@property (nonatomic, copy) NSString *coinid;
/** 交易货币ID */
@property (nonatomic, copy) NSString *unitcoinid;
/** 组合交易对名称 */
@property (nonatomic, copy) NSString *name;
/** 交易币 */
@property (nonatomic, copy) NSString *coinname;
/** 交易货币 */
@property (nonatomic, strong) NSString *unitcoinname;
/** 今日当前价 */
@property (nonatomic, copy) NSString *close_price;
/** 今日最高价 */
@property (nonatomic, copy) NSString *max_price;
/** 今日最低价 */
@property (nonatomic, copy) NSString *min_price;
/** 今日成交量 */
@property (nonatomic, copy) NSString *volume;
/** 涨跌幅 */
@property (nonatomic, copy) NSString *change;
/** 币小数点 前端币的小数点减1 10倍数 */
@property (nonatomic, strong) NSString *lot;
/** 价格小数点 */
@property (nonatomic, strong) NSString *ccylot;
/** 涨跌幅 */
@property (nonatomic, strong) NSString *changestr;

@end

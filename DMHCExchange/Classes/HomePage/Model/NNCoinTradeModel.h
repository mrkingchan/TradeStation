//
//  NNCoinTradeModel.h
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/24.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNCoinTradeModel : NSObject

/**名称*/
@property (nonatomic, strong) NSString *name;

/**成交价*/
@property (nonatomic, strong) NSString * newprice;

/**最低价*/

@property (nonatomic, strong) NSString *min_price;

/**最高价*/

@property (nonatomic, strong) NSString *max_price;

/**成交量*/
@property (nonatomic, strong) NSString *volume;

/**增长率*/

@property (nonatomic, strong) NSString *change;

/**增长率字符串*/
@property (nonatomic, strong) NSString *changestr;

/**coindid*/
@property (nonatomic, strong)  NSString *marketcoinid;

/**小数点*/
@property (nonatomic, strong) NSString *coin_round;

/**交易对小数点*/
@property (nonatomic, strong) NSString *unitcoin_round;

/**币名*/
@property (nonatomic, strong) NSString *coinname;

/**交易对明子*/
@property (nonatomic, strong) NSString *unitcoinname;

/**币id*/
@property (nonatomic, strong) NSString *coinid;

/**交易对id*/
@property (nonatomic, strong) NSString *unitcoinid;

@property (nonatomic, strong) NSString *tradeId;

@end

NS_ASSUME_NONNULL_END

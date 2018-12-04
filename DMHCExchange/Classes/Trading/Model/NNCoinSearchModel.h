//
//  NNCoinSearchKeyModel.h
//  DMHCExchange
//
//  Created by 牛牛 on 2018/11/6.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNCoinSearchModel : NSObject <NSCoding>

/** 交易对ID */
@property (nonatomic, copy) NSString *marketcoinid;
/** 组合交易对名称 */
@property (nonatomic, copy) NSString *name;
/** 交易币 */
@property (nonatomic, copy) NSString *coinname;
/** 交易货币 */
@property (nonatomic, strong) NSString *unitcoinname;
/** 币小数点 前端币的小数点减1 10倍数 */
@property (nonatomic, strong) NSString *coin_round;
/** 价格小数点 */
@property (nonatomic, strong) NSString *unitcoin_round;

@end

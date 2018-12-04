//
//  NNCoinTradingMarketModel.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/8/13.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNCoinTradingMarketModel.h"

@implementation NNCoinTradingMarketModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
               @"lot" : @"coin_round",
               @"ccylot" : @"unitcoin_round",
               @"close_price" : @"new_price"
             
            };
}

@end

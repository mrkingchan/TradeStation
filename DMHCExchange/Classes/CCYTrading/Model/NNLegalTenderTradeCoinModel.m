//
//  NNNNLegalTenderTradeCoinModel.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/29.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeCoinModel.h"

@implementation NNLegalTenderTradeCoinModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"currentPrice"  : @"new_price",
             };
}

@end

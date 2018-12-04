//
//  NNLegalTenderTradeReleaseCoinModel.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/30.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeReleaseCoinModel.h"

@implementation NNLegalTenderTradeReleaseCoinModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"currentPrice"  : @"new_price",
             @"coinid"        : @"id",
             };
}


@end

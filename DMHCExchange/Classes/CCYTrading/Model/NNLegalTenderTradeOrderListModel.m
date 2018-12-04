//
//  NNLegalTenderTradeOrderListModel.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/30.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeOrderListModel.h"

@implementation NNLegalTenderTradeOrderListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"orderID"  : @"id",
             };
}

@end

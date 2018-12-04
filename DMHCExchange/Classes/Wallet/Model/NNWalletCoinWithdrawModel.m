//
//  NNWalletCoinWithdrawModel.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/11/2.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNWalletCoinWithdrawModel.h"

@implementation NNWalletCoinWithdrawModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"fee" : @"zc_fee",
             };
}


@end

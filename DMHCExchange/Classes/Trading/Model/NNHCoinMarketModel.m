//
//  NNHCoinMarketModel.m
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/28.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNHCoinMarketModel.h"

@implementation NNHCoinMarketModel

+ (NSDictionary *)mj_objectClassInArray
{
    return  @{
              @"price" : @"NNHCoinPriceModel",
              };
}

@end

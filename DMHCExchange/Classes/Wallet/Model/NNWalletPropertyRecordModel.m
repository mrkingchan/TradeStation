//
//  NNWalletPropertyRecordModel.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/24.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNWalletPropertyRecordModel.h"

@implementation NNWalletPropertyRecordModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"directionType" : @"direction",
             };
}

@end

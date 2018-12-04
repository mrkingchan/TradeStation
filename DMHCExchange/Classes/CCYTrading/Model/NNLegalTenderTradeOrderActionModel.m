//
//  NNLegalTenderTradeOrderActionModel.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/30.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeOrderActionModel.h"

@implementation NNLegalTenderTradeOrderActionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"orderID" : @"id",
             };
}

- (NSMutableArray *)iconNameArray
{
    if (_iconNameArray == nil) {
        _iconNameArray = [NSMutableArray array];
        
        if ([self.isalipay isEqualToString:@"1"]) {
            [_iconNameArray addObject:@"tag_alipay"];
        }
        
        if ([self.iswechat isEqualToString:@"1"]) {
            [_iconNameArray addObject:@"tag_wechat_pay"];
        }
        
        if ([self.isbank isEqualToString:@"1"]) {
            [_iconNameArray addObject:@"tag_bank_card"];
        }
        
    }
    return _iconNameArray;
}

@end

//
//  NNCCYTradingModel.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/9/12.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNLegalTenderTradeModel.h"

@implementation NNLegalTenderTradeModel

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

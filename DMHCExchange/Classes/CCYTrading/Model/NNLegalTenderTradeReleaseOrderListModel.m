//
//  NNLegalTenderTradeReleaseOrderListModel.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/30.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNLegalTenderTradeReleaseOrderListModel.h"

@implementation NNLegalTenderTradeReleaseOrderListActionModel

@end

@implementation NNLegalTenderTradeReleaseOrderListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"tradeid"  : @"id",
             };
}

/** 暂时只有一种状态 */
- (NSString *)statusString
{
    if ([self.status isEqualToString:@"0"]) {
        return @"待成交";
    }
    return @"待成交";
}

@end

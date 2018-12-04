//
//  NNTradingEntrustModel.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/4/1.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNTradingEntrustModel.h"

@implementation NNTradingLogModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"logID" : @"id",
             @"price" : @"new_price"
             
             };
}

@end

@implementation NNTradingEntrustModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id", @"logs" : @"detailed"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"logs" : @"NNTradingLogModel"};
}

- (NSString *)statusText
{
    if ([_status integerValue] == 2){
        return @"已成交";
    }else{
        return @"已撤销";
    }
}

@end

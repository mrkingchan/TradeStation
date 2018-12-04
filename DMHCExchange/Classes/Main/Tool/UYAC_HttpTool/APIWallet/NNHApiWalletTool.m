//
//  NNHApiWalletTool.m
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/27.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNHApiWalletTool.h"

@implementation NNHApiWalletTool


- (instancetype)initWithWalletListDataWithKeyword:(NSString *)keyword
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"finance.coin.coinlist";
        self.reAPIName = @"资金模块 资金列表";
        if (!keyword) {
            keyword = @"";
        }
        self.reParams = @{
                          @"keyword"  : keyword,
                          };
    }
    return self;
}

- (instancetype)initWithCoinRechargeAddressDataWithCoinID:(NSString *)coinID
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"finance.coin.zr";
        self.reAPIName = @"资金模块 资金转入";
        if (!coinID) {
            coinID = @"";
        }
        self.reParams = @{
                          @"coinid"  : coinID,
                          };
    }
    return self;
}

- (instancetype)initWithCoinWithdrawDataWithCoinID:(NSString *)coinID
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"finance.coin.zc";
        self.reAPIName = @"资金转出信息显示";
        if (!coinID) {
            coinID = @"";
        }
        self.reParams = @{
                          @"coinid"  : coinID,
                          };
    }
    return self;
}

- (instancetype)initWithCoinWithdrawActionWithCoinID:(NSString *)coinID
                                                 num:(NSString *)num
                                         paypassword:(NSString *)paypassword
                                        moble_verify:(NSString *)moble_verify
                                             address:(NSString *)address
                                                memo:(NSString *)memo
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"finance.coin.upmyzc";
        self.reAPIName = @"资金转出提交";
        if (!coinID) {
            coinID = @"";
        }
        self.reParams = @{
                          @"coinid"         : coinID,
                          @"num"            : num,
                          @"paypassword"    : [paypassword md5String],
                          @"moble_verify"   : [self md5WithCode:moble_verify],
                          @"addr"           : address,
                          @"memo"           : memo,
                          };
    }
    return self;
}

- (instancetype)initWithCoinTransferListDataWithCoinID:(NSString *)coinID
                                                  type:(NSString *)type
                                                  page:(NSInteger)page
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"finance.coin.bill";
        self.reAPIName = @"账单信息";
        if (!coinID) {
            coinID = @"";
        }
        self.reParams = @{
                          @"coinid"  : coinID,
                          @"type"  : type,
                          @"page"  : [NSString stringWithFormat:@"%zd",page],
                          };
    }
    return self;
}

- (NSString *)md5WithCode:(NSString *)code
{
    NSString *string = [NSString stringWithFormat:@"%@%@",code,NNHAPI_PRIVATEKEY_IOS];
    return [string md5String];
}

@end

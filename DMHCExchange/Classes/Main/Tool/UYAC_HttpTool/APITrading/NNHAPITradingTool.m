//
//  NNHAPITradingTool.m
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/27.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           交易模块 api接口
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import "NNHAPITradingTool.h"

@implementation NNHAPITradingTool

- (instancetype)initMarketSymbol
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"ccTrade.trade.area";
        self.reAPIName = @"交易对";
    }
    return self;
}

- (instancetype)initCoinTradingMarketWithCCY:(NSString *)ccy
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"ccTrade.trade.pair";
        self.reAPIName = @"交易模块首页行情接口";
        self.reParams = @{@"marketid" : ccy};
    }
    return self;
}

- (instancetype)initSingleCoinTradingDataSourceWithCoinID:(NSString *)coinID
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"trade.price.rich";
        self.reAPIName = @"单个行情接口";
        self.reParams = @{@"coin" : coinID};
    }
    return self;
}

- (instancetype)initCoinIntroduceWithCoinID:(NSString *)coinID
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"index.index.hcoinintro";
        self.reAPIName = @"币种介绍";
        self.reParams = @{@"coin" : coinID};
    }
    return self;
}

- (instancetype)initTradingUserBalanceWithCoinID:(NSString *)coinID
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"ccTrade.trade.usable";
        self.reAPIName = @"用户余额 挂单用";
        
        self.reParams = @{
                              @"marketcoinid"  : coinID
                          };
    }
    return self;
}

- (instancetype)initTradingCoinNewPriceWithCoinID:(NSString *)coinID
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"ccTrade.trade.newprice";
        self.reAPIName = @"交易币种最新价格";
        
        self.reParams = @{
                          @"marketcoinid"  : coinID
                          };
    }
    return self;
}

- (instancetype)initCoinOrderWithOrderType:(NNHCoinTradingOrderType)orderType
                                    paypwd:(NSString *)paypwd
                                  coinName:(NSString *)coinName
                                    amount:(NSString *)amount
                                     price:(NSString *)price
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"ccTrade.trade.entrust";
        self.reAPIName = @"交易下单";
        
        NSString *type = @"1";
        if (orderType == NNHCoinTradingOrderType_soldOut) {
            type = @"2";
        }
        
        self.reParams = @{
                              @"totalnum"  : amount,
                              @"paypwd"    : [paypwd md5String],
                              @"price"     : price,
                              @"type"      : type,
                              @"symbol"    : coinName
                         };
    }
    return self;
}

- (instancetype)initTradingBuySellListWithWithCoinID:(NSString *)coinID
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"ccTrade.trade.entrustlist";
        self.reAPIName = @"挂单列表";
        
        self.reParams = @{@"marketcoinid"  : coinID};
    }
    return self;
}

- (instancetype)initCurrentEntrustListWithCoinID:(NSString *)coinID
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"ccTrade.trade.userentrust";
        self.reAPIName = @"用户当前委托";
        
        self.reParams = @{
                          @"marketcoinid"  : coinID,
                          @"type"     : @"1"
                          };
        
    }
    return self;
}

- (instancetype)initHistoryEntrustListWithWithCoinID:(NSString *)coinID
                                                page:(NSUInteger)page
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"ccTrade.trade.userentrust";
        self.reAPIName = @"用户历史委托";
        
        self.reParams = @{
                              @"marketcoinid"  : coinID,
                              @"type"     : @"0",
                              @"page"     : [NSString stringWithFormat:@"%zd",page]
                          };
    }
    
    return self;
}


- (instancetype)initCoinChartWithCoin:(NSString *)coin
                               period:(NSString *)period
                                  ccy:(NSString *)ccy
                                ctime:(NSString *)ctime
                                  num:(NSUInteger)num
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"market/kdata";
        self.reAPIName = @"k线接口";
        
        if (!num) {
            num = 60;
        }
        
        if (!ctime) {
            self.reParams = @{
                              @"symbol"   : coin,
                              @"period"   : period,
                              @"ccy"      : ccy,
                              @"num"      : [NSString stringWithFormat:@"%zd",num]
                              };
        }else{
            self.reParams = @{
                              @"symbol"   : coin,
                              @"period"   : period,
                              @"ccy"      : ccy,
                              @"time"     : ctime,
                              @"num"      : [NSString stringWithFormat:@"%zd",num]
                              };
        }
        
        
    }
    return self;
}

- (instancetype)initCancelOrderWithOrderno:(NSString *)orderno
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"ccTrade.trade.cancel";
        self.reAPIName = @"用户当前委托撤单";
        
        self.reParams = @{@"id"     : orderno};
    }
    return self;
}

- (instancetype)initCoinSearchWithCCYID:(NSString *)ccyID
                                keyword:(NSString *)keyword
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"ccTrade.trade.search";
        self.reAPIName = @"交易对搜索";
        
        self.reParams = @{@"marketid" : ccyID, @"keyword" : keyword};
    }
    return self;
}

@end

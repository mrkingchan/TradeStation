//
//  NNAPILegalTenderTool.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/26.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NNAPILegalTenderTool.h"

@implementation NNAPILegalTenderTool


- (instancetype)initReleaseOrderIndexDataWithCoinID:(NSString *)coinID
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"legal.trade.beforeuptrade";
        self.reAPIName = @"发布交易单 - 获取币种资料";
        if (!coinID) {
            coinID = @"";
        }
        self.reParams = @{
                          @"coinid"   : coinID,
                          };
    }
    return self;
}


- (instancetype)initReleaseOrderWithCoinID:(NSString *)coinID
                               paypassword:(NSString *)paypassword
                                     price:(NSString *)price
                                     count:(NSString *)count
                               limitAmount:(NSString *)limitAmount
                                    remark:(NSString *)remark
                                 tradeType:(NNLegalTenderTradeType)tradeType
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"legal.trade.uptrade";
        self.reAPIName = @"发布交易单 - 确认发布交易单";
        
        if (!coinID) {
            coinID = @"";
        }
        
        NSString *buyType = @"1";
        if (tradeType == NNLegalTenderTradeType_sell) {
            buyType = @"2";
        }
        self.reParams = @{
                          @"coinid"         :   coinID,
                          @"paypassword"    :   [paypassword md5String],
                          @"price"          :   price,
                          @"num"            :   count,
                          @"limit"          :   limitAmount,
                          @"desc"           :   remark,
                          @"price"          :   price,
                          @"buy_type"       :   buyType,
                          };
    }
    return self;
}

#pragma mark - 法币交易首页 订单列表

- (instancetype)initWithHomeCoinListData
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"legal.trade.getCoin";
        self.reAPIName = @"法币交易 - 获取首页所有交易对信息";
    }
    return self;
}

- (instancetype)initWithMatchOrderListDataWithTradeType:(NNLegalTenderTradeType)tradeType
                                                 coinID:(NSString *)coinID
                                                   page:(NSInteger)page
{
    self = [super init];
    if (self) {
        
        if (tradeType == NNLegalTenderTradeType_buy) {
            self.requestReServiceType = @"legal.trade.buywtlist";
            self.reAPIName = @"法币交易 - 首页购买列表";
        }else {
            self.requestReServiceType = @"legal.trade.sallwtlist";
            self.reAPIName = @"法币交易 - 获取出售列表";
        }
        
        if (!coinID) {
            coinID = @"";
        }
        
        self.reParams = @{
                          @"coinid"  :   coinID,
                          @"page"    :   [NSString stringWithFormat:@"%ld",page],
                          };
    }
    return self;
}

- (instancetype)initTradeActionCoinInfoWithTradeID:(NSString *)tradeID
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"legal.trade.buyselltrade";
        self.reAPIName = @"法币交易 - 挂单信息";
        
        if (!tradeID) {
            tradeID = @"";
        }
        self.reParams = @{
                          @"tradeid"  :   tradeID,
                          };
    }
    return self;
}

- (instancetype)initWithReleaseOrderListDataWithCoinID:(NSString *)coinID
                                                  page:(NSInteger)page
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"legal.trade.wtlist";
        self.reAPIName = @"法币交易 - 已发布交易单列表";
        
        if (!coinID) {
            coinID = @"";
        }
        self.reParams = @{
                          @"coinid"  :   coinID,
                          @"page"    :   [NSString stringWithFormat:@"%ld",page],
                          };
    }
    return self;
}

- (instancetype)initCancleReleaseOrderWithOrderID:(NSString *)orderID
                                           coinID:(NSString *)coinID
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"legal.trade.canceltrade";
        self.reAPIName = @"法币交易 - 撤销 已发布交易单";
        
        if (!orderID) {
            orderID = @"";
        }
        self.reParams = @{
                          @"coinid"  :   coinID,
                          @"tradeid"    :   orderID,
                          };
    }
    return self;
}

- (instancetype)initDoTradeWithTradeID:(NSString *)tradeID
                                number:(NSString *)number
                                amount:(NSString *)amount
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"legal.trade.dotrade";
        self.reAPIName = @"法币交易 - 买入卖出";
        
        if (!tradeID) {
            tradeID = @"";
        }
        self.reParams = @{
                          @"tradeid"  :   tradeID,
                          @"number"    :   number,
                          @"amount"    :   amount,
                          };
    }
    return self;
}

#pragma mark - 法币交易 交易记录

/**
 获取订单记录
 
 @param orderType 订单类型
 @return api
 */
- (instancetype)initOrderListDataWithOrderType:(NNLegalTenderTradeOrderListType)orderType
                                             coinID:(NSString *)coinID
                                               page:(NSInteger)page
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"legal.trade.histwtlist";
        self.reAPIName = @"法币交易 - 已撮合订单列表";
    
        if (!coinID) {
            coinID = @"";
        }
        self.reParams = @{
                          @"coinid"  :  coinID,
                          @"page"    :  [NSString stringWithFormat:@"%ld",page],
                          @"type"    :  [NSString stringWithFormat:@"%ld",orderType + 1],
                          };
    }
    return self;
}


#pragma mark - 法币交易 交易订单详情页面

/**
 获取订单详情页数据
 
 @param orderID 订单id
 @return api
 */
- (instancetype)initWithMatchOrderDetailWithOrderID:(NSString *)orderID
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"legal.trade.tradeinfo";
        self.reAPIName = @"法币交易 - 已撮合订单详情";
        
        if (!orderID) {
            orderID = @"";
        }
        self.reParams = @{
                          @"tradeid"  :  orderID,
                          };
    }
    return self;
}


- (instancetype)initOrderDetailBuyerCancleOrderWithOrderID:(NSString *)orderID
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"legal.trade.buycancellation";
        self.reAPIName = @"法币交易 - 订单详情 买家取消订单";
        
        if (!orderID) {
            orderID = @"";
        }
        self.reParams = @{
                          @"tradeid"  :  orderID,
                          };
    }
    return self;
}

- (instancetype)initOrderDetailBuyerConfirmPayOrderWithOrderID:(NSString *)orderID
                                                       paytype:(NSString *)paytype
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"legal.trade.paytrade";
        self.reAPIName = @"法币交易 - 订单详情 买家确认付款";
        
        if (!orderID) {
            orderID = @"";
        }
        self.reParams = @{
                          @"tradeid"  :  orderID,
                          @"paytype"  :  paytype,
                          };
    }
    return self;
}

- (instancetype)initOrderDetailSellerConfirmReceiveMoneyWithOrderID:(NSString *)orderID
                                                           password:(NSString *)password
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"legal.trade.confirmtrade";
        self.reAPIName = @"法币交易 - 订单详情 卖家确认收款";
        
        if (!orderID) {
            orderID = @"";
        }
        self.reParams = @{
                          @"tradeid"  :  orderID,
                          @"paypassword" : [password md5String],
                          };
    }
    return self;
}

- (instancetype)initOrderDetailUploadCertificateWithImgpath:(NSString *)imgpath
                                                    orderID:(NSString *)orderID
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"legal.trade.upcertificate";
        self.reAPIName = @"法币交易 - 订单详情 上传交易凭证";
        
        if (!orderID) {
            orderID = @"";
        }
        
        if (!imgpath) {
            imgpath = @"";
        }
        
        self.reParams = @{
                          @"tradeid"  :  orderID,
                          @"imgpath"  :  imgpath,
                          };
    }
    return self;
}


#pragma mark - 法币交易 交易订单 申诉

- (instancetype)initOrderAppleContentDataWithOrderID:(NSString *)orderID
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"legal.trade.getappeal";
        self.reAPIName = @"法币交易 - 获取申诉内容";
        
        if (!orderID) {
            orderID = @"";
        }
        self.reParams = @{
                          @"tradeid"  :  orderID,
                          };
    }
    return self;
}

- (instancetype)initSubmitAppealDataWithTradeID:(NSString *)tradeID
                                        content:(NSString *)content
                                           imgs:(NSString *)imgs
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"legal.trade.explaintrade";
        self.reAPIName = @"法币交易 - 提交交易申诉";
        
        self.reParams = @{
                          @"tradeid"  : tradeID,
                          @"imgs"     : imgs,
                          @"content"  : content,
                          };
    }
    return self;
}


- (instancetype)initUserTradeStatusWithType:(NSString *)type
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"legal.trade.middleware";
        self.reAPIName = @"法币交易 - 查看用户违规状态";
        
        if (!type) {
            type = @"";
        }
        
        self.reParams = @{
                          @"type"  : type,
                          };
    }
    return self;
}


@end

//
//  NNAPILegalTenderTool.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/26.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易模块 api 接口
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import "NNHBaseRequest.h"


@interface NNAPILegalTenderTool : NNHBaseRequest


#pragma mark - 发布 交易订单

/**
 发布交易单 获取基础信息
 
 @param coinID 币种id
 
 @return api
 */
- (instancetype)initReleaseOrderIndexDataWithCoinID:(NSString *)coinID;


/**
 确认发布订单

 @param coinID 币种id
 @param paypassword 资金密码
 @param price 发布价格
 @param count 发布数量
 @param limitAmount 最小限额
 @param remark 备注
 @param tradeType 发布类型
 @return api
 */
- (instancetype)initReleaseOrderWithCoinID:(NSString *)coinID
                               paypassword:(NSString *)paypassword
                                     price:(NSString *)price
                                     count:(NSString *)count
                               limitAmount:(NSString *)limitAmount
                                    remark:(NSString *)remark
                                 tradeType:(NNLegalTenderTradeType)tradeType;



#pragma mark - 法币交易首页 订单列表

/**
 获取法币交易 所有交易对信息
 
 @return api
 */
- (instancetype)initWithHomeCoinListData;


/**
 获取首页交易列表

 @param tradeType 交易类型
 @param coinID 币种id
 @param page 页码
 @return api
 */
- (instancetype)initWithMatchOrderListDataWithTradeType:(NNLegalTenderTradeType)tradeType
                                                 coinID:(NSString *)coinID
                                                   page:(NSInteger)page;


/**
 获取首页 发布交易单列表
 
 @param coinID 币种id
 @param page 页码
 @return api
 */
- (instancetype)initWithReleaseOrderListDataWithCoinID:(NSString *)coinID
                                                   page:(NSInteger)page;

/**
 取消发布的交易订单

 @param orderID 订单id
 @return api
 */
- (instancetype)initCancleReleaseOrderWithOrderID:(NSString *)orderID
                                           coinID:(NSString *)coinID;


/**
 买入或卖出订单 挂单信息预览页

 @param tradeID 交易id
 @return api
 */
- (instancetype)initTradeActionCoinInfoWithTradeID:(NSString *)tradeID;


/**
 买入卖出 币种下单

 @param tradeID 订单id
 @param number 交易数量
 @param amount 交易数量
 @return api
 */
- (instancetype)initDoTradeWithTradeID:(NSString *)tradeID
                                number:(NSString *)number
                                amount:(NSString *)amount;


#pragma mark - 法币交易 交易记录

/**
 获取订单记录

 @param orderType 订单类型
 @param coinID 币种id
 @param page 页码
 @return api
 */
- (instancetype)initOrderListDataWithOrderType:(NNLegalTenderTradeOrderListType)orderType
                                             coinID:(NSString *)coinID
                                               page:(NSInteger)page;



#pragma mark - 法币交易 交易订单详情页面

/**
 获取订单详情页数据

 @param orderID 订单id
 @return api
 */
- (instancetype)initWithMatchOrderDetailWithOrderID:(NSString *)orderID;


/**
 已撮合订单 买家取消订单

 @param orderID 订单id
 @return api
 */
- (instancetype)initOrderDetailBuyerCancleOrderWithOrderID:(NSString *)orderID;


/**
 买家确认付款

 @param orderID 订单did
 @param paytype 交易支付方式1支付宝2微信3银行卡
 @return api
 */
- (instancetype)initOrderDetailBuyerConfirmPayOrderWithOrderID:(NSString *)orderID
                                                       paytype:(NSString *)paytype;


/**
 已撮合订单  卖家确认收款

 @param orderID 订单id
 @return api
 */
- (instancetype)initOrderDetailSellerConfirmReceiveMoneyWithOrderID:(NSString *)orderID
                                                           password:(NSString *)password;


/**
 上传交易凭证

 @param imgpath 图片j路径
 @param orderID 交易id
 @return api
 */
- (instancetype)initOrderDetailUploadCertificateWithImgpath:(NSString *)imgpath
                                                    orderID:(NSString *)orderID;


#pragma mark - 法币交易 交易订单 申诉


/**
 获取订单申诉内容

 @return api
 */
- (instancetype)initOrderAppleContentDataWithOrderID:(NSString *)orderID;

/**
 交易申诉
 
 @param tradeID 订单号
 @param content 申诉文字内容
 @param imgs 图片
 @return api
 */
- (instancetype)initSubmitAppealDataWithTradeID:(NSString *)tradeID
                                        content:(NSString *)content
                                           imgs:(NSString *)imgs;



/**
 是否违禁

 @param type 订单类型
 @return API
 */
- (instancetype)initUserTradeStatusWithType:(NSString *)type;


@end


//
//  NNLegalTenderTradeOrderDetailModel.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/31.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易  已撮合订单 详情model
 
 @Remarks          vc
 
 *****************************************************/

#import <Foundation/Foundation.h>
#import "NNLegalTenderTradeOrderDetailPaymentModel.h"

typedef NS_ENUM(NSInteger, NNLegalTenderTradeTightItemOperationType) {
    NNLegalTenderTradeTightItemOperationType_cancle     = 0,      // 订单详情 取消
    NNLegalTenderTradeTightItemOperationType_appeal  = 1,        // 法币交易 申诉
    NNLegalTenderTradeTightItemOperationType_normal  = 2,        // 法币交易 正常
};

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeOrderDetailPayInfoModel : NSObject

/** 支付宝 */
@property (nonatomic, strong) NNLegalTenderTradeOrderDetailPaymentModel *alipay;

/** 银行卡 */
@property (nonatomic, strong) NNLegalTenderTradeOrderDetailPaymentModel *bank;

/** 微信 */
@property (nonatomic, strong) NNLegalTenderTradeOrderDetailPaymentModel *wechat;

@end

@interface NNLegalTenderTradeOrderDetailModel : NSObject

/**  */
@property (nonatomic, copy) NSString *amount;

/** 显示买家取消按钮 1 显示  */
@property (nonatomic, copy) NSString *buycancellation;

/** 法币名称 */
@property (nonatomic, copy) NSString *coinname;

/** 联系方式 */
@property (nonatomic, copy) NSString *mobile;

/** 数量 */
@property (nonatomic, copy) NSString *num;

/** 订单号 */
@property (nonatomic, copy) NSString *orderno;

/**  */
@property (nonatomic, copy) NSString *payimg;

/** 交易支付方式1支付宝2微信3银行卡 */
@property (nonatomic, copy) NSString *paytype;

/** 支付方式名称 */
@property (nonatomic, copy) NSString *paytypestr;

/** 单价 */
@property (nonatomic, copy) NSString *price;

/** 订单状态 */
@property (nonatomic, copy) NSString *status;

/** 订单状态说明 0 待交易（刚发布）,1 已买入未付款,2 已付款未确认,3 已确认付款（完结）,5 已撤销 6 买家取消 7买家违规 8卖家违规 */
@property (nonatomic, copy) NSString *statusstr;

/**  */
@property (nonatomic, copy) NSString *title;

/**  */
@property (nonatomic, copy) NSString *tradeid;

/** 交易类型(1为买入 2为卖出) */
@property (nonatomic, copy) NSString *type;

/**  */
@property (nonatomic, copy) NSString *username;

/** 用户id */
@property (nonatomic, copy) NSString *userid;

/** 下单时间 */
@property (nonatomic, copy) NSString *buytime;

/** 付款时间 */
@property (nonatomic, copy) NSString *paytime;

/** 放币时间与成交时间 */
@property (nonatomic, copy) NSString *endtime;

/** 按钮文字 */
@property (nonatomic, copy) NSString *actstr;

/** 剩余时间 */
@property (nonatomic, copy) NSString *last_time;

/** 违规原因 */
@property (nonatomic, copy) NSString *reason;

/** 支付方式 */
@property (nonatomic, strong) NNLegalTenderTradeOrderDetailPayInfoModel *payinfo;

#pragma mark - 辅助属性

/** 可选支付方式 */
@property (nonatomic, strong) NSMutableArray *paymentArray;

/** 选中的支付方式 */
@property (nonatomic, strong) NNLegalTenderTradeOrderDetailPaymentModel *selectedPayment;

/** 右上角item标题 */
@property (nonatomic, copy) NSString *rightItemTitle;

/** 右上角操作类型 */
@property (nonatomic, assign) NNLegalTenderTradeTightItemOperationType rightItmeType;

/** 支付密码 */
@property (nonatomic, copy) NSString *password;

@end

NS_ASSUME_NONNULL_END

//
//  NNLegalTenderTradeOrderDetailPaymentModel.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/31.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易  已撮合订单 详情页支付收款 model
 
 @Remarks          vc
 
 *****************************************************/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeOrderDetailPaymentModel : NSObject

/** 账号 */
@property (nonatomic, copy) NSString *account_number;

/** 开户银行名称 */
@property (nonatomic, copy) NSString *bank_type_name;

/** 支行信息*/
@property (nonatomic, copy) NSString *branch;

/**  图片 */
@property (nonatomic, copy) NSString *img;

/** 手机号码 */
@property (nonatomic, copy) NSString *mobile;

/** 用户名 */
@property (nonatomic, copy) NSString *name;

/** 支付方式 */
@property (nonatomic, assign) NNLegalTenderTradePaymentType paymentType;

/** 支付方式名称 */
@property (nonatomic, copy) NSString *paymentName;

@end

NS_ASSUME_NONNULL_END

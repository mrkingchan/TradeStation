//
//  NNLegalTenderTradeOrderSelectedPaymentTypeView.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/31.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易 用户 订单详情页 选择付款方式view
 
 @Remarks          vc
 
 *****************************************************/

#import <UIKit/UIKit.h>
@class NNLegalTenderTradeOrderDetailModel;
@class NNLegalTenderTradeOrderDetailPaymentModel;

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeOrderSelectedPaymentTypeView : UIView

/** 订单模型 */
@property (nonatomic, strong) NNLegalTenderTradeOrderDetailModel *orderModel;

/** 更改支付方式 */
@property (nonatomic, copy) void(^changedPaymentTypeBlock)(NNLegalTenderTradeOrderDetailPaymentModel *selectedPaymentModel);

/** 上传凭证按钮 回调 */
@property (nonatomic, copy) void(^uploadCertificateBlock)(void);

/** 查看凭证按钮 回调 */
@property (nonatomic, copy) void(^scanCertificateBlock)(void);

/** 查看收款方式 */
@property (nonatomic, copy) void(^scanPaymentCodePictureBlock)(void);

@end

NS_ASSUME_NONNULL_END

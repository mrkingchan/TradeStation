//
//  NNLegalTenderTradeOrderInfoView.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/29.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易 用户 订单详情页 订单信息
 
 @Remarks          vc
 
 *****************************************************/

#import <UIKit/UIKit.h>
#import "NNLegalTenderTradeOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeOrderInfoView : UIView

/** 订单模型 */
@property (nonatomic, strong) NNLegalTenderTradeOrderDetailModel *orderModel;

/** 联系对方回调 */
@property (nonatomic, copy) void (^contactActionBlock)(void);

@end

NS_ASSUME_NONNULL_END

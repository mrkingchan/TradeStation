//
//  NNLegalTenderTradeOrderBottomOperationView.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/31.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易 用户 订单详情页 底部操作view
 
 @Remarks          vc
 
 *****************************************************/

#import <UIKit/UIKit.h>
#import "NNLegalTenderTradeOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeOrderOperationView : UIView

/** 订单模型 */
@property (nonatomic, strong) NNLegalTenderTradeOrderDetailModel *orderModel;
/** 点击按钮 */
@property (nonatomic, copy) void(^orderOperationBlock)(void);
/** 倒计时回调 */
@property (nonatomic, copy) void(^endCountdownBlock)(void);

/** 停止倒计时 */
- (void)cancleCountDown;

@end

NS_ASSUME_NONNULL_END

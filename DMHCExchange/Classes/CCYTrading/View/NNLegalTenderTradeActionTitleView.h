//
//  NNLegalTenderTradeActionTitleView.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/26.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易 用户 下单页面 头部view
 
 @Remarks          vc
 
 *****************************************************/

#import <UIKit/UIKit.h>
@class NNLegalTenderTradeOrderActionModel;

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeActionTitleView : UIView

/** 订单数据 */
@property (nonatomic, strong) NNLegalTenderTradeOrderActionModel *orderModel;

@end

NS_ASSUME_NONNULL_END

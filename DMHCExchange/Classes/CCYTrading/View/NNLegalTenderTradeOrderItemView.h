//
//  NNLegalTenderTradeOrderItemView.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/29.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易 用户 订单详情页 每一行展示信息view
 
 @Remarks          view
 
 *****************************************************/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeOrderItemView : UIView

/** 内容label */
@property (nonatomic, strong) UILabel *messageLabel;
/** 标题文字 */
@property (nonatomic, copy) NSString *title;
/** 内容文字 */
@property (nonatomic, copy) NSString *message;

@end

NS_ASSUME_NONNULL_END

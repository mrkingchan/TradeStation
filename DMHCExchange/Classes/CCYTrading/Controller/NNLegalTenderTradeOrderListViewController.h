//
//  NNLegalTenderTradeOrderListViewController.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/25.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易 用户已成交订单 列表页面
 
 @Remarks          vc
 
 *****************************************************/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeOrderListViewController : UIViewController


/**
 初始化

 @param coinID 币种id
 @return api
 */
- (instancetype)initWithCoinID:(NSString *)coinID;

@end

NS_ASSUME_NONNULL_END

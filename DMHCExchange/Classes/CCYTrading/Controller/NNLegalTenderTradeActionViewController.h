//
//  NNLegalTenderTradeActionViewController.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/25.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易 撮合订单列表 点击 下单撮合页面
 
 @Remarks          vc
 
 *****************************************************/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeActionViewController : UIViewController


/**
 初始化

 @param tradeID 交易id
 @return api
 */
- (instancetype)initWithTradeID:(NSString *)tradeID;

@end

NS_ASSUME_NONNULL_END

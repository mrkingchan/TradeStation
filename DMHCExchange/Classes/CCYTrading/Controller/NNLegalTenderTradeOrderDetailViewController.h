//
//  NNLegalTenderTradeOrderDetailViewController.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/25.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易 用户已成交订单详情页面
 
 @Remarks          vc
 
 *****************************************************/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeOrderDetailViewController : UIViewController

/** 从下单页面push进来 */
@property (nonatomic, assign) BOOL fromActionVC;

/**
 初始化

 @param orderID 订单id
 @return api
 */
- (instancetype)initWithOrderID:(NSString *)orderID;

@end

NS_ASSUME_NONNULL_END

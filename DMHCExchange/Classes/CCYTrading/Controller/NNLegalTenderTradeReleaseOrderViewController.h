//
//  NNLegalTenderTradeReleaseOrderViewController.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/25.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易 用户发布 订单页面
 
 @Remarks          vc
 
 *****************************************************/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeReleaseOrderViewController : UIViewController


/**
 c初始化

 @param coinID 发布币种id
 @param coinName 发布币种名称
 @return vc
 */
- (instancetype)initWithCoinID:(NSString *)coinID coinName:(NSString *)coinName;


@end

NS_ASSUME_NONNULL_END

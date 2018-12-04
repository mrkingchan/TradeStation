//
//  NNHHistoryEntrustViewController.h
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/20.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           币种交易历史委托页面
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import "NNExchangeChildViewController.h"
@class NNCoinTradingMarketModel;

@interface NNHHistoryEntrustViewController : NNExchangeChildViewController

/**
 初始化

 @return 控制器对象
 */
- (instancetype)initWithCoinTradingMarketModel:(NNCoinTradingMarketModel *)model;


@end

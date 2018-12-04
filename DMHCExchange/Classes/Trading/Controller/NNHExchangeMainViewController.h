//
//  NNHExchangeMainViewController.h
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/20.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           交易主界面
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import <UIKit/UIKit.h>
#import "NNCoinTradingMarketModel.h"

@interface NNHExchangeMainViewController : UIViewController

/**
 初始化
 @return 控制器对象
 */
- (instancetype)initWithCoinTradingMarketModel:(NNCoinTradingMarketModel *)model;

/** 进入页面默认控制器下标 */
@property (nonatomic, assign) NSInteger index;

@end

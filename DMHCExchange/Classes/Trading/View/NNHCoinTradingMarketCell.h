//
//  NNHCoinTradingMarketCell.h
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/5.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           行情首页cell
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import <UIKit/UIKit.h>
@class NNCoinTradingMarketModel;

@interface NNHCoinTradingMarketCell : UITableViewCell

/** 模型数据 */
@property (nonatomic, strong) NNCoinTradingMarketModel *coinTradingMarketModel;

@end

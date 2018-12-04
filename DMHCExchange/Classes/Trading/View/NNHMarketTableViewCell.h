//
//  NNHMarketTableViewCell.h
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/5.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           行情首页cell
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import <UIKit/UIKit.h>
@class NNHCoinPriceModel;

@interface NNHMarketTableViewCell : UITableViewCell

/** <#注释#> */
@property (nonatomic, strong) NNHCoinPriceModel *priceModel;

@end

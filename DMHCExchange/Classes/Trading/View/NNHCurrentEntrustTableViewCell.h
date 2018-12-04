//
//  NNHCurrentEntrustTableViewCell.h
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/20.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           交易界面，当前委托界面cell
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import <UIKit/UIKit.h>
@class NNTradingEntrustModel;

@interface NNHCurrentEntrustTableViewCell : UITableViewCell

@property (nonatomic, strong) NNTradingEntrustModel *tradingEntrustModel;

/** 撤销操作 */
@property (nonatomic, copy) void(^cancleBlock)(void);

@end

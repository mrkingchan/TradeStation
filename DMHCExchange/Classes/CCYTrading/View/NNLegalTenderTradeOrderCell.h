//
//  NNCCYTradingOrderCell.h
//  SuperWallet
//
//  Created by 牛牛 on 2018/9/13.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易 用户 已成交订单cell
 
 @Remarks          vc
 
 *****************************************************/

#import <UIKit/UIKit.h>
@class NNLegalTenderTradeOrderListModel;

@interface NNLegalTenderTradeOrderCell : UITableViewCell

@property (nonatomic, strong) NNLegalTenderTradeOrderListModel *orderListModel;

@end

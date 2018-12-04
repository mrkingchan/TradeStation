//
//  NNLegalTenderReleaseListCell.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/26.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易 用户发布待成交订单  cell
 
 @Remarks          vc
 
 *****************************************************/

#import <UIKit/UIKit.h>
@class NNLegalTenderTradeReleaseOrderListModel;

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderReleaseListCell : UITableViewCell

/** 订单模型 */
@property (nonatomic, strong) NNLegalTenderTradeReleaseOrderListModel *orderModel;

/** 撤销订单 */
@property (nonatomic, copy) void (^cancleOperationBlock)(void);

@end

NS_ASSUME_NONNULL_END

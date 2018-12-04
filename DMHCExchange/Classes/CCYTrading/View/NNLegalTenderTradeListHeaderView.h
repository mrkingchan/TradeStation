//
//  NNLegalTenderTradeListHeaderView.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/30.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易 撮合页面 头部余额view
 
 @Remarks          vc
 
 *****************************************************/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeListHeaderView : UIView

/** 可用余额 */
@property (nonatomic, copy) NSString *availableAmount;

/** 可用余额 */
@property (nonatomic, copy) NSString *freezeAmount;

/** 币种名称 */
@property (nonatomic, copy) NSString *coinName;

@end

NS_ASSUME_NONNULL_END

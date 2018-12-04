//
//  NNLegalTenderTradeSelectMarketView.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/29.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易 主页 选择 交易对
 
 @Remarks          view
 
 *****************************************************/

#import <UIKit/UIKit.h>
#import "NNLegalTenderTradeCoinModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeSelectMarketCell : UICollectionViewCell

/** 币种名称 */
@property (nonatomic, strong) NSString *coinName;

@end



@interface NNLegalTenderTradeSelectMarketView : UIView

/** 选择完后的回调 */
@property (nonatomic, copy) void(^selectedMarketCompleteBlock)(NNLegalTenderTradeCoinModel *coinModel);

/** 数据源数组 */
@property (nonatomic, strong) NSArray <NNLegalTenderTradeCoinModel *>*dataSource;

- (void)show;

@end

NS_ASSUME_NONNULL_END

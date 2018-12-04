//
//  NNNNLegalTenderTradeCoinModel.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/29.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易  首页 币种模型
 
 @Remarks          vc
 
 *****************************************************/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeCoinModel : NSObject
/** 币种id */
@property (nonatomic, copy) NSString *coinid;
/** 名称-中文 */
@property (nonatomic, copy) NSString *coinname;
/** 当前价格 */
@property (nonatomic, copy) NSString *currentPrice;
@end

NS_ASSUME_NONNULL_END

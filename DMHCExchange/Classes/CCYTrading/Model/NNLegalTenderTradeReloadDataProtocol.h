//
//  NNLegalTenderTradeReloadDataProtocol.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/30.
//  Copyright © 2018 超级钱包. All rights reserved.
//


/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易  首页 列表刷新 列表数据
 
 @Remarks          vc
 
 *****************************************************/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NNLegalTenderTradeReloadDataProtocol <NSObject>


/**
 刷新数据
 */
- (void)reloadNetworkData;


/**
 修改coinid 刷新数据

 @param coinID 币种id
 */
- (void)reloadCoinListDataWithCoinID:(NSString *)coinID coinName:(NSString *)coinName;

@end

NS_ASSUME_NONNULL_END

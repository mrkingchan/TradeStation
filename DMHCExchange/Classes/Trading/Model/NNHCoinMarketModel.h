//
//  NNHCoinMarketModel.h
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/28.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           币种行情模块
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import <Foundation/Foundation.h>
@class NNHCoinPriceModel;

@interface NNHCoinMarketModel : NSObject

/** 币种id */
@property (nonatomic, copy) NSString *coin;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 行情数据 */
@property (nonatomic, strong) NSArray <NNHCoinPriceModel  *>*price;

@end

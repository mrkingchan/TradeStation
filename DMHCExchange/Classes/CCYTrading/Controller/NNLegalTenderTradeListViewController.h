//
//  NNLegalTenderTradeListViewController.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/25.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易 撮合订单列表页 购买列表 和出售列表页面
 
 @Remarks          vc
 
 *****************************************************/

#import <UIKit/UIKit.h>
#import "NNLegalTenderTradeReloadDataProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeListViewController : UIViewController


/**
 法币交易 待撮合列表 页面

 @param tradeType 订单类型
 @return api
 */
- (instancetype)initWithTradeType:(NNLegalTenderTradeType)tradeType;

@end

NS_ASSUME_NONNULL_END

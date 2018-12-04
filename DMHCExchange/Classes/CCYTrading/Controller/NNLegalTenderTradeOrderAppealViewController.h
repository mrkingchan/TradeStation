//
//  NNLegalTenderTradeOrderAppealViewController.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/26.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易 订单申诉页面
 
 @Remarks          vc
 
 *****************************************************/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeOrderAppealViewController : UIViewController

/**
 初始化申诉页面
 
 @param orderID 订单id
 @return 对象
 */
- (instancetype)initWithOrderID:(NSString *)orderID;

/** 申诉成功后刷新按钮 */
@property (nonatomic, copy) void(^reloadDataBlock)(void);

@end

NS_ASSUME_NONNULL_END

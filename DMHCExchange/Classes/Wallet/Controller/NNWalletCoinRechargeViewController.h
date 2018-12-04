//
//  NNWalletCoinRechargeViewController.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/24.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           钱包 币种充值页面
 
 @Remarks          vc
 
 *****************************************************/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNWalletCoinRechargeViewController : UIViewController


/**
 初始化

 @param coinID 币种id
 @return vc
 */
- (instancetype)initWithCoinID:(NSString *)coinID coinName:(NSString *)coinName;

@end

NS_ASSUME_NONNULL_END

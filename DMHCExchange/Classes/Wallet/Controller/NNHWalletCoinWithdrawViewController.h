//
//  NNHWalletCoinWithdrawViewController.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/24.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           币种提现页面
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNHWalletCoinWithdrawViewController : UIViewController

/**
 初始化对象
 
 @param coinID 币种ID
 @param coinName 币种名称
 @return 控制器对象
 */
- (instancetype)initWithCoinID:(NSString *)coinID coinName:(NSString *)coinName;

@end

NS_ASSUME_NONNULL_END

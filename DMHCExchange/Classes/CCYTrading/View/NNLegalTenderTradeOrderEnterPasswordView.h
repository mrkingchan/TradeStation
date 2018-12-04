//
//  NNLegalTenderTradeOrderEnterPasswordView.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/29.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeOrderEnterPasswordView : UIView

/** 输入支付密码 */
@property (nonatomic, copy) void (^passwordActionBlock)(NSString *password);

@end

NS_ASSUME_NONNULL_END

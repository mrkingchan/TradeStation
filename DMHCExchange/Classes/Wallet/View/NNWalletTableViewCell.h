//
//  NNWalletTableViewCell.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/24.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NNWalletPropertyModel;

typedef NS_ENUM(NSInteger, NNHWalletOperationType) {
    NNHWalletOperationType_recharge  = 0,      // 充值
    NNHWalletOperationType_withdraw  = 1,      // 提现
    NNHWalletOperationType_record  = 2,        // 账单
};

NS_ASSUME_NONNULL_BEGIN

@interface NNWalletTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^walletOperationBlock)(NNHWalletOperationType type);

/** 资产模型 */
@property (nonatomic, strong) NNWalletPropertyModel *propertyModel;

@end

NS_ASSUME_NONNULL_END

//
//  NNWalletCoinWithdrawModel.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/11/2.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNWalletCoinWithdrawModel : NSObject

/** coinname */
@property (nonatomic, copy) NSString *coinname;

/** 类型1比特型2以太坊3以太坊代币4EOS(4的时候要显示memo) */
@property (nonatomic, copy) NSString *cointype;

/** 描述 */
@property (nonatomic, copy) NSString *desc;

/** 手机号 */
@property (nonatomic, copy) NSString *moble;

/** 转账地址 */
@property (nonatomic, copy) NSString *total;

/** 地址二维码 */
@property (nonatomic, copy) NSString *totald;

/** 地址二维码 */
@property (nonatomic, copy) NSString *warning;

/** 矿工号 */
@property (nonatomic, copy) NSString *fee;

@end

NS_ASSUME_NONNULL_END

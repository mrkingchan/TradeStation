//
//  NNWalletCoinRechargeModel.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/11/2.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNWalletCoinRechargeModel : NSObject

/** 类型1比特型2以太坊3以太坊代币4EOS(4的时候要显示memo) */
@property (nonatomic, copy) NSString *cointype;

/** 描述 */
@property (nonatomic, copy) NSString *desc;

/** 标签 */
@property (nonatomic, copy) NSString *memo;

/** 转账地址 */
@property (nonatomic, copy) NSString *address;

/** 地址二维码 */
@property (nonatomic, copy) NSString *codeUrl;
@end

NS_ASSUME_NONNULL_END

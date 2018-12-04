//
//  NNWalletPropertyModel.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/24.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNWalletPropertyModel : NSObject

/** 币种资料 */
@property (nonatomic, copy) NSString *coinid;

/** 是否启动【1为启用 2位禁止 如果为2用户点击提示该币种已经关闭等信息，如果是1点击跳转详情页】 */
@property (nonatomic, copy) NSString *enable;

/** 币种中文名 */
@property (nonatomic, copy) NSString *coinname;

/** 币种英文简称 */
@property (nonatomic, copy) NSString *coinname_abb;

/** 币种对应的图片 */
@property (nonatomic, copy) NSString *img;

/** 当前币种的数量 */
@property (nonatomic, copy) NSString *coinamount;

/** 当前币种的冻结数量 */
@property (nonatomic, copy) NSString *fut_coinamount;

/** 当前币种的全部数量 */
@property (nonatomic, copy) NSString *all_coinamount;

/** 价格 【读取amounttype来判断显示$还是￥】  */
@property (nonatomic, copy) NSString *coinprice;

/** 是否显示体现 */
@property (nonatomic, copy) NSString *is_show_extract;

/** 是否显示充值 */
@property (nonatomic, copy) NSString *is_show_recharge;

@end

NS_ASSUME_NONNULL_END

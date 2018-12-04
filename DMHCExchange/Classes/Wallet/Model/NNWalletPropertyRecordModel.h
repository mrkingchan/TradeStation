//
//  NNWalletPropertyRecordModel.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/24.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNWalletPropertyRecordModel : NSObject

/** amount */
@property (nonatomic, copy) NSString *amount;

/** 收支情况(1 收入 2 支出) */
@property (nonatomic, copy) NSString *directionType;

/** 手续费显示 */
@property (nonatomic, copy) NSString *feetext;

/** 手续费显示 */
@property (nonatomic, copy) NSString *flowname;

/** 时间 */
@property (nonatomic, copy) NSString *flowtime;

/**  */
@property (nonatomic, copy) NSString *flowtype;

/** 状态文字显示 */
@property (nonatomic, copy) NSString *statustext;

/** 币种名称 */
@property (nonatomic, copy) NSString *coinname;

@end

NS_ASSUME_NONNULL_END

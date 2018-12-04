//
//  NNMineShareRewardModel.h
//  DMHCExchange
//
//  Created by 牛牛 on 2018/10/24.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNMineShareRewardModel : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *nickname;
/** 时间 */
@property (nonatomic, copy) NSString *time;
/** 数量 */
@property (nonatomic, copy) NSString *amount;
/** 币种 */
@property (nonatomic, copy) NSString *unit;
/** 状态描述文字 */
@property (nonatomic, copy) NSString *statusstr;
/** 收支情况(1 收入 2 支出) */
@property (nonatomic, copy) NSString *direction;

@end

//
//  NSString+NNHCalculte.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/11/7.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           字符串精度计算
 
 @Remarks          vc
 
 *****************************************************/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (NNHCalculte)

/** 加法 */
- (NSString *)calculateByAdding:(NSString *)stringNumer;

/** 减法 */
- (NSString *)calculateBySubtracting:(NSString *)stringNumer;

/** 乘法 */
- (NSString *)calculateByMultiplying:(NSString *)stringNumer;

/** 除法 */
- (NSString *)calculateByDividing:(NSString *)stringNumer;

/** 幂次方 */
- (NSString *)calculateByRaising:(NSUInteger)power;

/** 四舍五入 scale 保留小数位数  */
- (NSString *)calculateByRounding:(NSUInteger)scale;

/** 是否相等  */
- (BOOL)calculateIsEqual:(NSString *)stringNumer;

/** 是否大于  */
- (BOOL)calculateIsGreaterThan:(NSString *)stringNumer;

/** 是否小于  */
- (BOOL)calculateIsLessThan:(NSString *)stringNumer;

/** 转成小数  */
- (double)calculateDoubleValue;

@end

NS_ASSUME_NONNULL_END

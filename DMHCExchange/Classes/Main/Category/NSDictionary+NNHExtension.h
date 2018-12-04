//
//  NSDictionary+NNHExtension.h
//  DMHCAMU
//
//  Created by 来旭磊 on 17/3/29.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (NNHExtension)

/**
 返回一个新数组，其中包含已排序的字典键
 */
- (NSArray *)allKeysSorted;

/**
 返回一个新数组，其中包含按键排序的字典值
 */
- (NSArray *)allValuesSortedByKeys;

/**
 字典是否有键的对象
 */
- (BOOL)containsObjectForKey:(id)key;

/**
 返回字符串
 */
- (nullable NSString *)jsonStringEncoded;

/**
 返回字符串
 */
- (nullable NSString *)jsonPrettyStringEncoded;


@end

NS_ASSUME_NONNULL_END

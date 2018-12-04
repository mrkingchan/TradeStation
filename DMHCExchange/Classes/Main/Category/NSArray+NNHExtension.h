//
//  NSArray+NNHExtension.h
//  DMHCAMU
//
//  Created by 牛牛 on 2018/10/23.
//  Copyright © 2018年 牛牛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NNHExtension)

/**
 返回字符串
 */
- (nullable NSString *)jsonStringEncoded;

/**
 返回字符串
 */
- (nullable NSString *)jsonPrettyStringEncoded;

@end

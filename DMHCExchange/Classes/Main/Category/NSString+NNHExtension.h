//
//  NSString+NNHExtension.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 牛牛汇. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (NNHExtension)

#pragma mark - Hash
///=============================================================================
/// @name Hash
///=============================================================================

/**
 Returns a lowercase NSString for md5 hash.
 */
- (nullable NSString *)md5String;


#pragma mark - Encode and decode
///=============================================================================
/// @name Encode and decode
///=============================================================================

/**
 URL encode a string in utf-8.
 @return the encoded string.
 */
- (NSString *)stringByURLEncode;

/**
 URL decode a string in utf-8.
 @return the decoded string.
 */
- (NSString *)stringByURLDecode;

/**
 Escape common HTML to Entity.
 Example: "a>b" will be escape to "a&gt;b".
 */
- (NSString *)stringByEscapingHTML;


#pragma mark - Regular Expression
///=============================================================================
/// @name Regular Expression
///=============================================================================

/** 是否为纯数字 */
- (BOOL)nn_isValidNumber;

/** 电话号码 */
- (BOOL)checkIsPhoneNumber;

/** 检测是否为邮箱 */
- (BOOL)checkIsEmail;

/** 验证身份证号（15位或18位数字） */
- (BOOL)checkIsCardNumber;

/** 检测是否是昵称 只包含数字 字母 下划线 中文 且8-16位 */
- (BOOL)checkIsValidateNickname;

/** 正则匹配用户密码 6 - 20 位数字和字母组合 */
- (BOOL)checkPassWord;

/** 校验银行卡格式 */
+ (BOOL)checkCardNum:(NSString*)cardNum;

/* 检测字符串是否为空 */
+ (BOOL)isEmptyString:(NSString *)string;

// 判断字符串内容是否合法：2-12位汉字、字母、数字
- (BOOL)validateFormatByRegexForString:(NSString *)string;


#pragma mark - Utilities
///=============================================================================
/// @name Utilities
///=============================================================================

/**
 获取格式时间

 @param stamp 时间戳
 @return 获取格式时间
 */
+ (NSString *)dateStringWithTimeStamp:(NSString *)stamp;

/**
 *
 *  @brief  毫秒时间戳 例如 1443066826371
 *
 *  @return 毫秒时间戳
 */
+ (NSString *)nn_Timestamp;


/** 获取url所有参数 */
- (NSDictionary *)getUrlParameters;

/**
 nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 */
- (BOOL)isNotBlank;

/**
 Returns an NSData using UTF-8 encoding.
 */
- (nullable NSData *)dataValue;

/**
 返回解码后的NSDictionary/NSArray 
 e.g. NSString: @"{"name":"a","count":2}"  => NSDictionary: @[@"name":@"a",@"count":@2]
 */
- (nullable id)jsonValueDecoded;

/** 安全处理 **** */
- (NSString *)replaceStringWithAsterisk:(NSInteger)startLocation length:(NSInteger)length;

/** 谁调用就计算谁的size */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END

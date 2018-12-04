//
//  NSDate+NNHExtension.h
//  ElegantTrade
//
//  Created by 牛牛 on 2017/2/27.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (NNHExtension)

#pragma mark - Component Properties
///=============================================================================
/// @name Component Properties
///=============================================================================

@property (nonatomic, readonly) NSInteger year; ///< 年
@property (nonatomic, readonly) NSInteger month; ///< 月 (1~12)
@property (nonatomic, readonly) NSInteger day; ///< 天 (1~31)
@property (nonatomic, readonly) NSInteger hour; ///< 时 (0~23)
@property (nonatomic, readonly) NSInteger minute; ///< 分 (0~59)
@property (nonatomic, readonly) NSInteger second; ///< 秒 (0~59)
@property (nonatomic, readonly) NSInteger nanosecond; ///< 纳秒
@property (nonatomic, readonly) NSInteger weekday; ///< 周
@property (nonatomic, readonly) NSInteger weekdayOrdinal; ///< 工作日
@property (nonatomic, readonly) NSInteger weekOfMonth; ///< 每个月的第几周 (1~5)
@property (nonatomic, readonly) NSInteger weekOfYear; ///< //每年的第几周 (1~53)
@property (nonatomic, readonly) NSInteger yearForWeekOfYear; ///< YearForWeekOfYear component
@property (nonatomic, readonly) NSInteger quarter; ///< 季度
@property (nonatomic, readonly) BOOL isLeapMonth; ///< 是否为闰月
@property (nonatomic, readonly) BOOL isLeapYear; ///< 是否为闰年
@property (nonatomic, readonly) BOOL isToday; ///< 今天
@property (nonatomic, readonly) BOOL isYesterday; ///< 昨天

#pragma mark - Date modify
///=============================================================================
/// @name Date modify
///=============================================================================

/**
 Returns a date representing the receiver date shifted later by the provided number of years.
 
 @param years  Number of years to add.
 @return Date modified by the number of desired years.
 */
- (nullable NSDate *)dateByAddingYears:(NSInteger)years;

/**
 Returns a date representing the receiver date shifted later by the provided number of months.
 
 @param months  Number of months to add.
 @return Date modified by the number of desired months.
 */
- (nullable NSDate *)dateByAddingMonths:(NSInteger)months;

/**
 Returns a date representing the receiver date shifted later by the provided number of weeks.
 
 @param weeks  Number of weeks to add.
 @return Date modified by the number of desired weeks.
 */
- (nullable NSDate *)dateByAddingWeeks:(NSInteger)weeks;

/**
 Returns a date representing the receiver date shifted later by the provided number of days.
 
 @param days  Number of days to add.
 @return Date modified by the number of desired days.
 */
- (nullable NSDate *)dateByAddingDays:(NSInteger)days;

/**
 Returns a date representing the receiver date shifted later by the provided number of hours.
 
 @param hours  Number of hours to add.
 @return Date modified by the number of desired hours.
 */
- (nullable NSDate *)dateByAddingHours:(NSInteger)hours;

/**
 Returns a date representing the receiver date shifted later by the provided number of minutes.
 
 @param minutes  Number of minutes to add.
 @return Date modified by the number of desired minutes.
 */
- (nullable NSDate *)dateByAddingMinutes:(NSInteger)minutes;

/**
 Returns a date representing the receiver date shifted later by the provided number of seconds.
 
 @param seconds  Number of seconds to add.
 @return Date modified by the number of desired seconds.
 */
- (nullable NSDate *)dateByAddingSeconds:(NSInteger)seconds;


#pragma mark - Date Format
///=============================================================================
/// @name Date Format
///=============================================================================

/**
 日期的格式化字符串
 
 @param format @"yyyy-MM-dd HH:mm:ss"
 */
- (nullable NSString *)stringWithFormat:(NSString *)format;

/**
 日期的格式化字符串
 
 @param format @"yyyy-MM-dd HH:mm:ss"
 */
- (nullable NSString *)stringWithFormat:(NSString *)format
                               timeZone:(nullable NSTimeZone *)timeZone
                                 locale:(nullable NSLocale *)locale;

/**
 返回 ISO8601 格式 "2010-07-09T16:13:30+12:00"
 */
- (nullable NSString *)stringWithISOFormat;

/**
 返回指定格式解析的日期。
 */
+ (nullable NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

/**
 返回指定格式解析的日期。
 */
+ (nullable NSDate *)dateWithString:(NSString *)dateString
                             format:(NSString *)format
                           timeZone:(nullable NSTimeZone *)timeZone
                             locale:(nullable NSLocale *)locale;

/**
 返回使用ISO8601格式给定字符串解析的日期
 */
+ (nullable NSDate *)dateWithISOFormatString:(NSString *)dateString;

@end

NS_ASSUME_NONNULL_END

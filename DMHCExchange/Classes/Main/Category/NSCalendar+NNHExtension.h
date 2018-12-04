//
//  NSCalendar+NNHExtension.h
//  ElegantTrade
//
//  Created by 牛牛 on 2017/2/27.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (NNHExtension)

/** 当前的日期数据元件模型 */
+ (NSDateComponents *)currentDateComponents;

/** 当前年 */
+ (NSInteger)currentYear;

/** 当前月 */
+ (NSInteger)currentMonth;

/** 当前天 */
+ (NSInteger)currentDay;

/** 当前周数 */
+ (NSInteger)currnentWeekday;

/** 获取指定年月的天数 */
+ (NSInteger)getDaysWithYear:(NSInteger)year
                       month:(NSInteger)month;

/** 获取指定年月的第一天的周数 */
+ (NSInteger)getFirstWeekdayWithYear:(NSInteger)year
                               month:(NSInteger)month;

/** 字符串转日期元件 字符串格式为：yy-MM-dd */
+ (NSDateComponents *)dateComponentsWithString:(NSString *)String;



@end

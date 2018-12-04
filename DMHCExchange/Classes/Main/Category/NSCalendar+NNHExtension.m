//
//  NSCalendar+NNHExtension.m
//  ElegantTrade
//
//  Created by 牛牛 on 2017/2/27.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

#import "NSCalendar+NNHExtension.h"

@implementation NSCalendar (NNHExtension)

/** 当前的日期数据元件模型 */
+ (NSDateComponents *)currentDateComponents
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    return [calendar components:unitFlags fromDate:[NSDate date]];
}

+ (NSInteger)currentMonth
{
    return [NSCalendar currentDateComponents].month;
}

+ (NSInteger)currentYear
{
    return [NSCalendar currentDateComponents].year;
}

+ (NSInteger)currentDay
{
    return [NSCalendar currentDateComponents].day;
}

+ (NSInteger)currnentWeekday
{
    return [NSCalendar currentDateComponents].weekday;
}

/** 根据年月 获取当相应月份的天数 */
+ (NSInteger)getDaysWithYear:(NSInteger)year
                       month:(NSInteger)month
{
    switch (month) {
        case 1:
            return 31;
            break;
        case 2:
            if (year%400==0 || (year%100!=0 && year%4 == 0)) {
                return 29;
            }else{
                return 28;
            }
            break;
        case 3:
            return 31;
            break;
        case 4:
            return 30;
            break;
        case 5:
            return 31;
            break;
        case 6:
            return 30;
            break;
        case 7:
            return 31;
            break;
        case 8:
            return 31;
            break;
        case 9:
            return 30;
            break;
        case 10:
            return 31;
            break;
        case 11:
            return 30;
            break;
        case 12:
            return 31;
            break;
        default:
            return 0;
            break;
    }
}

/** 根据相应年月获取当相应的周是周几 */
+ (NSInteger)getFirstWeekdayWithYear:(NSInteger)year
                               month:(NSInteger)month
{
    NSString *stringDate = [NSString stringWithFormat:@"%ld-%ld-01", (long)year, (long)month];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yy-MM-dd"];
    NSDate *date = [formatter dateFromString:stringDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:date];
    return [components weekday];
}

/** 字符串转日期元件 字符串格式为：yy-MM-dd */
+ (NSDateComponents *)dateComponentsWithString:(NSString *)String
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yy-MM-dd"];
    NSDate *date = [formatter dateFromString:String];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    return  [calendar components:unitFlags fromDate:date];
}

@end



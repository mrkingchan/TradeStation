//
//  NSString+NNHCalculte.m
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/11/7.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import "NSString+NNHCalculte.h"

@implementation NSString (NNHCalculte)

- (NSString *)calculateByAdding:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSDecimalNumber *addingNum = [num1 decimalNumberByAdding:num2];
    return [addingNum stringValue];
}

- (NSString *)calculateBySubtracting:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSDecimalNumber *subtractingNum = [num1 decimalNumberBySubtracting:num2];
    return [subtractingNum stringValue];
}

- (NSString *)calculateByMultiplying:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSDecimalNumber *multiplyingNum = [num1 decimalNumberByMultiplyingBy:num2];
    return [multiplyingNum stringValue];
}

- (NSString *)calculateByDividing:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSDecimalNumber *dividingNum = [num1 decimalNumberByDividingBy:num2];
    return [dividingNum stringValue];
    
}

- (NSString *)calculateByRaising:(NSUInteger)power
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *raisingNum = [num1 decimalNumberByRaisingToPower:power];
    return [raisingNum stringValue];
    
}

- (NSString *)calculateByRounding:(NSUInteger)scale
{
    NSDecimalNumberHandler * handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundDown scale:scale raiseOnExactness:NO raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *roundingNum = [num1 decimalNumberByRoundingAccordingToBehavior:handler];
    return [roundingNum stringValue];
}

- (BOOL)calculateIsEqual:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    if (result == NSOrderedSame) {
        return YES;
    }
    return NO;
}

- (BOOL)calculateIsGreaterThan:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    if (result == NSOrderedDescending) {
        return YES;
    }
    return NO;
    
}

- (BOOL)calculateIsLessThan:(NSString *)stringNumer
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:stringNumer];
    NSComparisonResult result = [num1 compare:num2];
    if (result == NSOrderedAscending) {
        return YES;
    }
    return NO;
    
}

- (double)calculateDoubleValue
{
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:self];
    return [num doubleValue];
}



@end

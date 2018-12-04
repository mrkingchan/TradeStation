//
//  NSTimer+NNHExtension.m
//  DMHCAMU
//
//  Created by 来旭磊 on 2017/6/14.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

#import "NSTimer+NNHExtension.h"

@implementation NSTimer (NNHExtension)

/** 暂停计时器 */
-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    
    [self setFireDate:[NSDate distantFuture]];
}

/** 恢复计时器 */
-(void)resumeTimer
{
    if ([self isValid]) {
        return ;
    }

    [self setFireDate:[NSDate date]];
}

@end

//
//  NSData+NNHExtension.m
//  DMHCAMU
//
//  Created by 牛牛 on 2018/10/23.
//  Copyright © 2018年 牛牛. All rights reserved.
//

#import "NSData+NNHExtension.h"

@implementation NSData (NNHExtension)

- (id)jsonValueDecoded
{
    NSError *error = nil;
    id value = [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:&error];
    if (error) {
        NSLog(@"jsonValueDecoded error:%@", error);
    }
    return value;
}

@end

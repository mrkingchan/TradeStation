//
//  NNHMyGroup.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/23.
//  Copyright © 2016年 Smile intl. All rights reserved.
//  一个group ＝＝ 一个section

#import <Foundation/Foundation.h>

@interface NNHMyGroup : NSObject

/** 组头 */
@property (nonatomic, copy) NSString *header;
/** 组尾 */
@property (nonatomic, copy) NSString *footer;
/** 存放的是item模型 */
@property (nonatomic, strong) NSArray *items;

+ (instancetype)group;

@end

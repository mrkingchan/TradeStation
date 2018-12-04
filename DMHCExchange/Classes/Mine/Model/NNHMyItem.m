//
//  NNHMyItem.m
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/23.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import "NNHMyItem.h"

@implementation NNHMyItem

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon itemAccessoryViewType:(NNHItemAccessoryViewType)type
{
    NNHMyItem *item = [[self alloc] init];
    item.title = title;
    if (![NSString isEmptyString:icon]) item.icon = icon;
    item.type = type;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title itemAccessoryViewType:(NNHItemAccessoryViewType)type
{
    return [self itemWithTitle:title icon:@"" itemAccessoryViewType:type];
}

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon
{
    return [self itemWithTitle:title icon:icon itemAccessoryViewType:NNHItemAccessoryViewTypeNormal];
}

@end

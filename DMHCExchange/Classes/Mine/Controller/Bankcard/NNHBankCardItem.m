//
//  NNHBankCardItem.m
//  NNCivetCat
//
//  Created by 来旭磊 on 17/3/30.
//  Copyright © 2017年 灵猫. All rights reserved.
//

#import "NNHBankCardItem.h"

@implementation NNHBankCardItem

+ (instancetype)itemWithName:(NSString *)name itemPlaceHolder:(NSString *)placeHolder
{
    NNHBankCardItem *item = [[NNHBankCardItem alloc] init];
    item.itemName = name;
    item.itemPlaceHolder = placeHolder;
    return item;
}

+ (instancetype)itemWithName:(NSString *)name itemRightText:(NSString *)rightText
{
    NNHBankCardItem *item = [[NNHBankCardItem alloc] init];
    item.itemName = name;
    item.itemRightText = rightText;
    return item;
}

@end

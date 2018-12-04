//
//  NNShareModel.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/4/3.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNShareModel.h"

@implementation NNShareModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"share_title" : @"title",
             @"share_content" : @"intro",
             @"share_image" : @"img",
             @"share_url" : @"uri"
             };
}

@end

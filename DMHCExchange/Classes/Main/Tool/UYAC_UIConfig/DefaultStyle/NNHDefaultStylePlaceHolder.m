//
//  NNHDefaultStylePlaceHolder.m
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/18.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import "NNHDefaultStylePlaceHolder.h"

@implementation NNHDefaultStylePlaceHolder

/** banner图   600*300px 2:1**/
- (NSString *)NNH_placeHolder_banner
{
    return  @"store_banner_pacehold";
}

/** 商品占位图 **/
- (NSString *)NNH_placeHolder_product
{
    return @"product_pacehold";
}

/** 商品详情 广告 **/
- (NSString *)NNH_placeHolder_GoodsDetailAD
{
    return @"商品大图占位.png";
}
    
/** 商品主页动态占位图 **/
- (NSString *)NNH_placeHolder_dynamic
{
    return @"default_ dynamic.png";
}

/** 身份证 **/
- (NSString *)NNH_placeHolder_card
{
    return @"身份证占位.png";
}

@end

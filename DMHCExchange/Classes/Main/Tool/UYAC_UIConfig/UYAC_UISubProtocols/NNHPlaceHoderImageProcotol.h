//
//  NNHPlaceHoderImageProcotol.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/18.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NNHPlaceHoderImageProcotol <NSObject>

@optional

/** banner图   600*300px 2:1**/
- (NSString *)NNH_placeHolder_banner;

/** 商品占位图 **/
- (NSString *)NNH_placeHolder_product;

/** 商品主页动态占位图 **/
- (NSString *)NNH_placeHolder_dynamic;

/** 商品详情 广告 **/
- (NSString *)NNH_placeHolder_GoodsDetailAD;

/** 身份证 **/
- (NSString *)NNH_placeHolder_card;

@end

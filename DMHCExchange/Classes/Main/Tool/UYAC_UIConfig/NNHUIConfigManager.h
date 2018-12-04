//
//  NNHUIConfigManager.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/18.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNHUISettingProtocols.h"

#ifndef UIConfigManager
#define UIConfigManager  [NNHUIConfigManager sharedManager]
#endif

typedef NS_ENUM(NSInteger, NNHUIStyle) {
    NNHUIStyle_Default,
    NNHUIStyle_Other,
};

@interface NNHUIConfigManager : NSObject<
    NNHFontProtocol,
    NNHColorProtocol,
    NNHPlaceHoderImageProcotol
>


+ (instancetype)sharedManager;

/**
 *  返回以iPhone 6 屏幕宽度为基准，等比伸缩后的数值
 *  适用: 1. 把设计稿宽度拉到375, 然后用截图软件测量距离
 *       2. 设计稿是以6的屏幕基准标注的距离
 *  
 */
+ (CGFloat)widthCompareWithStandardScreenWidth:(CGFloat)designValue;

@end

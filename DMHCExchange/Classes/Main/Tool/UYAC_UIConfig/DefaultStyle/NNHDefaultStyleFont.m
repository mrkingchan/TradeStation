//
//  NNHDefaultStyleFont.m
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/18.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import "NNHDefaultStyleFont.h"

static NSString * kFontName = @"STHeitiSC-Light";
// 这个字体没有加粗版...
static NSString * kBoldFontName = @"STHeitiSC-Bold";
static NSString * kObliqueFontName = @"STHeitiSC-Oblique";

@implementation NNHDefaultStyleFont


- (UIFont *)fontWithSize:(CGFloat)fontSize
{
//    return [UIFont fontWithName:kFontName size:fontSize];
    return [UIFont systemFontOfSize:fontSize];
}

- (UIFont *)fontBoldWithSize:(CGFloat)fontSize
{
    return [UIFont systemFontOfSize:fontSize];
}

- (UIFont *)fontOliqueWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:kObliqueFontName size:fontSize];
}


#pragma mark -
#pragma mark ---------设计稿的字体

/** 少数重要标题 **/
- (UIFont *)fontThemeMostImportantTitles
{
    return [self fontBoldWithSize:20];
}

/** 详情商品文字 **/
- (UIFont *)fontThemeLargerBtnTitles
{
    return [self fontWithSize:16];
}

/** 较为重要的文字 如分类名称 价格等 **/
- (UIFont *)fontThemeTextImportant
{
    return [self fontWithSize:15];
}

/** 正文字体 用于标题 价格 小按钮title等 **/
- (UIFont *)fontThemeTextMain
{
    return [self fontWithSize:14];
}

/** 大部分文字字体 **/
- (UIFont *)fontThemeTextDefault
{
    return [self fontWithSize:13];
}

/** 辅助性提示文字 **/
- (UIFont *)fontThemeTextTip
{
    return [self fontWithSize:12];
}

/** 辅助性提示文字 **/
- (UIFont *)fontThemeTextMinTip
{
    return [self fontWithSize:10];
}

#pragma mark -
#pragma mark ---------NavigationBar
/** 大按钮上的字体   黑体**/
- (UIFont *)fontNaviTitle{
    return [self fontWithSize:18];
}

/** 导航按钮图片下面的小字体 **/
- (UIFont *)fontNaviBarButtonTitle
{
    return [self fontWithSize:14];
}

@end

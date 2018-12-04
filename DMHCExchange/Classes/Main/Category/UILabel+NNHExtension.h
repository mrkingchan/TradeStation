//
//  UILabel+NNHExtension.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 牛牛汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (NNHExtension)

/** 自定义Label **/
+ (UILabel *)NNHWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font;


/**
 添加富文本

 @param attrText 添加富文本的文字
 @param font 富文本的字体
 @param color 富文本的颜色
 */
- (void)nnh_addAttringTextWithText:(NSString *)attrText font:(UIFont *)font color:(UIColor *)color;


/**
 添加行间距

 @param lineSpace 行间距
 */
- (void)nnh_addLineSpaceWithLineSpace:(CGFloat)lineSpace;


@end

//
//  UIColor+NNHExtension.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 牛牛汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NNHExtension)

/** 随机颜色 **/
+ (UIColor *)akext_randomColor;

/**
 *十六进制颜色转换
 */
+ (UIColor*)akext_colorWithHex:(NSString*)hexValue;

@end

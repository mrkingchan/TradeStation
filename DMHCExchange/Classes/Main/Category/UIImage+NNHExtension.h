//
//  UIImage+NNHExtension.h
//  ElegantTrade
//
//  Created by 来旭磊 on 16/10/31.
//  Copyright © 2016年 牛牛汇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (NNHExtension)

/**
 裁剪
 */
- (nullable UIImage *)imageByCropToRect:(CGRect)rect;

/**
 添加圆角
 */
- (nullable UIImage *)imageByRoundCornerRadius:(CGFloat)radius;

/**
 添加圆角
 */
- (nullable UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                                   borderWidth:(CGFloat)borderWidth
                                   borderColor:(nullable UIColor *)borderColor;


/** 根据颜色生成图片 */
+ (nullable UIImage *)nnh_imageWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END

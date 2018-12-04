//
//  UIButton+NNHExtension.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 牛牛汇. All rights reserved.
//

typedef NS_ENUM(NSInteger, NNHOperationButtonType){
    NNHOperationButtonTypeRed = 1, // 红色背景
    NNHOperationButtonTypeGrey = 2, // 灰色背景
    NNHOperationButtonTypeYellow = 3 // 黄色背景
};

#import <UIKit/UIKit.h>

@interface UIButton (NNHExtension)

// 返回button（title ➕ 边框）
+ (UIButton *)NNHBorderBtnTitle:(NSString *)title borderColor:(UIColor *)borderColor titleColor:(UIColor *)titleColor;

// 返回button（自定义字体、颜色、背景）
+ (UIButton *)NNHBtnTitle:(NSString *)title titileFont:(UIFont *)titleFont backGround:(UIColor *)backgroundColor  titleColor:(UIColor *)titlecolor;

// 返回button（只含图片 点击事件）
+ (UIButton *)NNHBtnImage:(NSString *)image target:(id)target action:(SEL)action;

// 返回操作按钮
+ (UIButton *)NNHOperationBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action operationButtonType:(NNHOperationButtonType)type isAddCornerRadius:(BOOL)addCornerRadius;

// 设置背景颜色
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end

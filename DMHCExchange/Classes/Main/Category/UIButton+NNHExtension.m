//
//  UIButton+NNHExtension.m
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 牛牛汇. All rights reserved.
//

#import "UIButton+NNHExtension.h"

@implementation UIButton (NNHExtension)

// 返回button（title ➕ 边框）
+ (UIButton *)NNHBorderBtnTitle:(NSString *)title borderColor:(UIColor *)borderColor titleColor:(UIColor *)titleColor
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIConfigManager fontThemeTextDefault];
    btn.layer.borderColor = borderColor.CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 2.0;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    return btn;
}

// 返回button（自定义字体、颜色、背景）
+ (UIButton *)NNHBtnTitle:(NSString *)title titileFont:(UIFont *)titleFont backGround:(UIColor *)backgroundColor  titleColor:(UIColor *)titlecolor
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titlecolor forState:UIControlStateNormal];
    [btn.titleLabel setFont:titleFont];
    [btn setBackgroundColor:backgroundColor];
    return btn;
}

// 返回button（只含图片 点击事件）
+ (UIButton *)NNHBtnImage:(NSString *)image target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:ImageName(image) forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIButton *)NNHOperationBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action operationButtonType:(NNHOperationButtonType)type isAddCornerRadius:(BOOL)addCornerRadius
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIConfigManager colorThemeWhite] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIConfigManager fontThemeLargerBtnTitles]];
    
    if (type == NNHOperationButtonTypeRed) {
        [btn setBackgroundColor:[UIConfigManager colorThemeRed] forState:UIControlStateNormal];
    }else if (type == NNHOperationButtonTypeGrey){
        [btn setTitleColor:[UIConfigManager colorThemeDarkGray] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIConfigManager colorThemeSeperatorDarkGray] forState:UIControlStateNormal];
    }else{
        [btn setBackgroundColor:[UIColor akext_colorWithHex:@"f19634"] forState:UIControlStateNormal];
    }
    [btn setBackgroundColor:[UIConfigManager colorThemeDisable] forState:UIControlStateDisabled];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.adjustsImageWhenHighlighted = NO;
//    if (addCornerRadius) {
//        btn.layer.cornerRadius = NNHOperationButtonRadiu;
//        btn.clipsToBounds = YES;
//    }
    return btn;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[self imageWithColor:backgroundColor] forState:state];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(contex, [color CGColor]);
    CGContextFillRect(contex, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

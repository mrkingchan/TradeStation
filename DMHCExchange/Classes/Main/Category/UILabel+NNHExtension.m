//
//  UILabel+NNHExtension.m
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 牛牛汇. All rights reserved.
//

#import "UILabel+NNHExtension.h"

@implementation UILabel (NNHExtension)

/** 自定义Label **/
+ (UILabel *)NNHWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = titleColor;
    label.font = font;
    return label;
}

/**
 添加富文本
 
 @param attrText 添加富文本的文字
 @param font 富文本的字体
 @param color 富文本的颜色
 */
- (void)nnh_addAttringTextWithText:(NSString *)attrText font:(UIFont *)font color:(UIColor *)color
{
    if (attrText.length == 0 || !attrText) return;
    if (self.text.length == 0) return;
    NSRange range = [self.text rangeOfString:attrText];
    if (range.location != NSNotFound) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.text];
        if (font) {
            [attrString addAttribute:NSFontAttributeName value:font range:range];
        }
        if (color) {
            [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
        self.attributedText = attrString;
    }
}


- (void)nnh_addLineSpaceWithLineSpace:(CGFloat)lineSpace
{
    if (self.text.length == 0) return;
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    
    self.attributedText = attributedStr;
}

@end

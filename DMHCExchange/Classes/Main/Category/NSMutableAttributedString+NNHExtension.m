//
//  NSMutableAttributedString+NNHExtension.m
//  DMHCAMU
//
//  Created by 牛牛 on 2017/8/16.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

#import "NSMutableAttributedString+NNHExtension.h"
#import <CoreText/CoreText.h>

@implementation NSMutableAttributedString (NNHExtension)

/**
 *  单纯改变一句话中的某些字的颜色（一种颜色）
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组(要是有相同的 只取第一个)
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)nn_changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray
{
    if (subArray.count == 0) return nil;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    for (NSString *rangeStr in subArray) {
        NSMutableArray *array = [self nn_getRangeWithTotalString:totalStr SubString:rangeStr];
        
        for (NSNumber *rangeNum in array) {
            NSRange range = [rangeNum rangeValue];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
            [attributedStr addAttribute:NSFontAttributeName value:[UIConfigManager fontThemeTextDefault] range:range];
        }
    }
    return attributedStr;
}

/**
 *  单纯改变句子的字间距（需要 <CoreText/CoreText.h>）
 *
 *  @param totalString 需要更改的字符串
 *  @param space       字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)nn_changeSpaceWithTotalString:(NSString *)totalString Space:(CGFloat)space
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    CGFloat number = space;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];
    CFRelease(num);
    return attributedStr;
}

/**
 *  单纯改变段落的行间距
 *
 *  @param totalString 需要更改的字符串
 *  @param lineSpace   行间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)nn_changeLineSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    return attributedStr;
}

/**
 *  添加图片
 *
 *  @param totalString 需要改变的字符串
 *  @param image   需要添加的图片
 *  @param imageRect 图片大小
 *  @param atIndex   添加位置
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)nn_addImageWithTotalString:(NSString *)totalString image:(NSString *)image imageRect:(CGRect)imageRect atIndex:(NSInteger)atIndex
{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:totalString];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:image];
    attch.bounds = imageRect;
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    // 在文字下标第几个添加图片  0就是文字前面添加图片
    [attri insertAttributedString:string atIndex:atIndex];
    
    return attri;
}

/**
 *  同时更改行间距和字间距
 *
 *  @param totalString 需要改变的字符串
 *  @param lineSpace   行间距
 *  @param textSpace   字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)nn_changeLineAndTextSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    
    CGFloat number = textSpace;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];
    CFRelease(num);
    
    return attributedStr;
}

/**
 *  改变某些文字的颜色 并单独设置其字体
 *
 *  @param font        设置的字体
 *  @param color       颜色
 *  @param totalString 总的字符串
 *  @param subArray    想要变色的字符数组
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)nn_changeFontAndColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    for (NSString *rangeStr in subArray) {
        NSRange range = [totalString rangeOfString:rangeStr options:NSBackwardsSearch];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    }
    
    return attributedStr;
}

#pragma mark - 获取某个子字符串在某个总字符串中位置数组
/**
 *  获取某个字符串中子字符串的位置数组
 *
 *  @param totalString 总的字符串
 *  @param subString   子字符串
 *
 *  @return 位置数组
 */
+ (NSMutableArray *)nn_getRangeWithTotalString:(NSString *)totalString SubString:(NSString *)subString
{
    NSMutableArray *arrayRanges = [NSMutableArray array];
    NSRange rang = [totalString rangeOfString:subString];
    
    if (rang.location != NSNotFound && rang.length != 0) {
        
        [arrayRanges addObject:[NSNumber valueWithRange:rang]];
        
        NSRange      rang1 = {0,0};
        NSInteger location = 0;
        NSInteger   length = 0;
        
        for (NSInteger i = 0;; i++) {
            
            if (0 == i) {
                
                location = rang.location + rang.length;
                length = totalString.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            } else {
                
                location = rang1.location + rang1.length;
                length = totalString.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            
            rang1 = [totalString rangeOfString:subString options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0) {
                
                break;
            } else {
                
                [arrayRanges addObject:[NSNumber valueWithRange:rang1]];
            }
        }
        
        return arrayRanges;
    }
    
    return nil;
}

/*!
 @method
 @brief    固定价格写法 (现金➕牛贝)
 */
+ (NSAttributedString *)attributedString:(NSString *)string
{
    NSRange range1 = [string rangeOfString:@"元"];
    NSRange range3 = [string rangeOfString:@"+"];
    NSRange range2 = [string rangeOfString:NNHCurrency];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string];
    if (range1.length > 0) {
        [att addAttributes:@{NSFontAttributeName : [UIConfigManager fontThemeTextTip],
                             NSForegroundColorAttributeName : [UIConfigManager colorThemeDark]}
                     range:NSMakeRange(range1.location, 1)];
    }
    if (range2.length > 0) {
        [att addAttributes:@{NSFontAttributeName : [UIConfigManager fontThemeTextTip],
                             NSForegroundColorAttributeName : [UIConfigManager colorThemeDark]}
                     range:NSMakeRange(range2.location, 2)];
    }
    if (range3.length > 0) {
        [att addAttributes:@{NSFontAttributeName : [UIConfigManager fontThemeTextTip],
                             NSForegroundColorAttributeName : [UIConfigManager colorThemeDark]}
                     range:NSMakeRange(range3.location, 1)];
    }
    return att;
}

+ (NSAttributedString *)attributedStringWithPrice:(NSString *)price amount:(NSString *)amount bull:(NSString *)bull
{
    if (!price) return nil;
    if (!amount) return nil;
    NSRange bullRange = [price rangeOfString:bull];
    NSRange amountRange = [price rangeOfString:amount];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:price];
    if (amountRange.location != NSNotFound) {
        [att addAttributes:@{
                             NSForegroundColorAttributeName : [UIConfigManager colorThemeRed]}
                     range:amountRange];
    }
    if (bullRange.location != NSNotFound) {
        [att addAttributes:@{
                             NSForegroundColorAttributeName : [UIConfigManager colorThemeRed]}
                     range:bullRange];
    }
    
    return att;
}

@end

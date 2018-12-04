//
//  NSMutableAttributedString+NNHExtension.h
//  DMHCAMU
//
//  Created by 牛牛 on 2017/8/16.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (NNHExtension)

/**
 *  单纯改变一句话中的某些字的颜色 默认字体为13
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)nn_changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray;


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
+ (NSMutableAttributedString *)nn_changeFontAndColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray;


/**
 *  单纯改变句子的字间距（需要 <CoreText/CoreText.h>）
 *
 *  @param totalString 需要更改的字符串
 *  @param space       字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)nn_changeSpaceWithTotalString:(NSString *)totalString Space:(CGFloat)space;

/**
 *  单纯改变段落的行间距
 *
 *  @param totalString 需要更改的字符串
 *  @param lineSpace   行间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)nn_changeLineSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace;


/**
 *  同时更改行间距和字间距
 *
 *  @param totalString 需要改变的字符串
 *  @param lineSpace   行间距
 *  @param textSpace   字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)nn_changeLineAndTextSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace;



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
+ (NSMutableAttributedString *)nn_addImageWithTotalString:(NSString *)totalString image:(NSString *)image imageRect:(CGRect)imageRect atIndex:(NSInteger)atIndex;



/*!
 @method
 @brief    固定价格写法 (现金➕牛贝)
 */
+ (NSAttributedString *)attributedString:(NSString *)string;


/**
 商品价格富文本
 @param price 金额字符串
 @param amount 钱数
 @param bull 牛豆
 @return 富文本
 */
+ (NSAttributedString *)attributedStringWithPrice:(NSString *)price amount:(NSString *)amount bull:(NSString *)bull;


@end

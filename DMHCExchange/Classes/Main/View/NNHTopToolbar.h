//
//  ZPMainTopToolbar.h
//  Test
//
//  Created by 牛牛 on 16/2/24.
//  Copyright © 2016年 牛牛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NNHTopToolbar;

@protocol NNHTopToolbarDelegate <NSObject>

- (void)topToolbar:(NNHTopToolbar *)toolbar didSelectedButton:(UIButton *)button;

@end

@interface NNHTopToolbar : UIView

/** 代理 */
@property (nonatomic, weak) id <NNHTopToolbarDelegate> delegate;
/** 顶部索引 跳转第几个 赋值必须在代理前 */
@property (nonatomic, assign) NSInteger index;
/** 底部横线的高度 */
@property (nonatomic, assign) CGFloat lineHeight;
/** 文字 */
@property (nonatomic, strong) NSArray *titles;

/*!
 @method
 @brief   初始化
 @param   font 默认13  normalColor 默认黑色  selectedColor 默认金色
 
 */
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                    titleFont:(UIFont *)font
                  normalColor:(UIColor *)normalColor
                selectedColor:(UIColor *)selectedColor;

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles;

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                    titleFont:(UIFont *)font;


@end

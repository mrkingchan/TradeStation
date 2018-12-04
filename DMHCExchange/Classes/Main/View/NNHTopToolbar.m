//
//  ZPMainTopToolbar.m
//  Test
//
//  Created by 牛牛 on 16/2/24.
//  Copyright © 2016年 牛牛. All rights reserved.
//

#import "NNHTopToolbar.h"

@interface NNHTopToolbar()

/** 底部标记线条 */
@property (nonatomic, strong) UIView *indicatorView;
/** 当前选中的按钮 */
@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation NNHTopToolbar

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
{
    return [self initWithFrame:frame titles:titles titleFont:[UIConfigManager fontThemeTextMain] normalColor:[UIConfigManager colorThemeDark] selectedColor:[UIConfigManager colorThemeRed]];
}

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                    titleFont:(UIFont *)font
{
    return [self initWithFrame:frame titles:titles titleFont:font normalColor:[UIConfigManager colorThemeDark] selectedColor:[UIConfigManager colorThemeRed]];
}

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                    titleFont:(UIFont *)font
                  normalColor:(UIColor *)normalColor
                selectedColor:(UIColor *)selectedColor
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 设置默认值
        _lineHeight = 1;
        
        // 内部的子标签
        CGFloat width = self.nnh_width / titles.count;
        CGFloat height = self.nnh_height;
        for (NSInteger i = 0; i< titles.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.nnh_height = height;
            button.nnh_width = width;
            button.nnh_x = i * width;
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:normalColor forState:UIControlStateNormal];
            [button setTitleColor:selectedColor forState:UIControlStateDisabled];
            button.titleLabel.font = font;
            [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            // 默认点击了第一个按钮
            if (i == 0) {
                button.enabled = NO;
                _selectedButton = button;
                // 让按钮内部的label根据文字内容来计算尺寸
                [button.titleLabel sizeToFit];
                _indicatorView.nnh_width = button.titleLabel.nnh_width + 20;
                _indicatorView.nnh_centerX = button.nnh_centerX;
            }
        }
        
        // 底部指示器, 加在button后面便于从subviews里取button
        self.indicatorView.backgroundColor = selectedColor;
        [self addSubview:self.indicatorView];
    }
    return self;
}

- (void)setLineHeight:(CGFloat)lineHeight
{
    _lineHeight = lineHeight;
    self.indicatorView.nnh_height = lineHeight;
    self.indicatorView.nnh_y = self.nnh_height - lineHeight;
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    
    for (NSInteger i = 0; i< titles.count; i++) {
        if ([self.subviews[i] isKindOfClass:[UIButton class]]) {
            UIButton *button = self.subviews[i];
            [button setTitle:titles[i] forState:UIControlStateNormal];
        }
    }
    
    // 重新计算底部标记线条的宽度
    [self.selectedButton.titleLabel sizeToFit];
    _indicatorView.nnh_width = self.selectedButton.titleLabel.nnh_width + 20;
    _indicatorView.nnh_centerX = self.selectedButton.nnh_centerX;
}

- (void)setDelegate:(id<NNHTopToolbarDelegate>)delegate
{
    _delegate = delegate;
    if (self.index) {
        [self titleClick:self.subviews[self.index]];
    }else{
        [self titleClick:[self.subviews firstObject]];
    }
}

- (void)titleClick:(UIButton *)button
{
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        [button.titleLabel sizeToFit];
        self.indicatorView.nnh_width = button.titleLabel.nnh_width + 20;
        self.indicatorView.nnh_centerX = button.nnh_centerX;
    }];
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(topToolbar:didSelectedButton:)]) {
        [self.delegate topToolbar:self didSelectedButton:button];
    }
}

- (UIView *)indicatorView
{
    if (_indicatorView == nil) {
        _indicatorView = [[UIView alloc] init];
        _indicatorView.nnh_height = 1;
        _indicatorView.nnh_y = self.nnh_height - _indicatorView.nnh_height;
    }
    return _indicatorView;
}

@end

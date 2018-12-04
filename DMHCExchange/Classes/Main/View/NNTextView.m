//
//  NNHTextView.m
//  NNHPlatform
//
//  Created by leiliao lai on 17/3/1.
//  Copyright © 2017年 Smile intl. All rights reserved.
//

#import "NNTextView.h"

@implementation NNTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholderColor = [UIConfigManager colorTextLightGray];

        // 只要监听object发出name这个通知 就会调用self的textChange这个方法
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)textChange
{
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    // setNeedsDisplay会在下一个消息循环时刻，调用drawRect:
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}


// 每当调用一次 就会擦除之前所画的
- (void)drawRect:(CGRect)rect
{
    if (self.hasText) return;  // 如果有输入文字，就直接返回，不画占位文字
    
    CGFloat x = 5;
    CGFloat y = 8;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat h = rect.size.height - 2 * y;
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font ? self.font : [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = self.placeholderColor ? self.placeholderColor : [UIColor grayColor];
    [self.placeholder drawInRect:CGRectMake(x, y, w, h) withAttributes:attrs];
}
@end

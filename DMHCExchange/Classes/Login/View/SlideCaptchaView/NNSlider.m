//
//  NNSlider.m
//  code
//
//  Created by 牛牛 on 2018/11/2.
//  Copyright © 2018年 Wicky. All rights reserved.
//

#import "NNSlider.h"
#import "UIImage+DWImageUtils.h"

@implementation NNSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setThumbImage:[UIImage imageNamed:@"ic_slide_login"] forState:UIControlStateNormal];
        [self setThumbImage:[UIImage imageNamed:@"ic_slide_login_pressed"] forState:UIControlStateHighlighted];
        [self setMinimumTrackImage:[UIImage imageNamed:@"slide_bar"] forState:UIControlStateNormal];
        [self setMinimumTrackImage:[UIImage imageNamed:@"slide_bar_pressed"] forState:UIControlStateHighlighted];
        [self setMaximumTrackImage:[UIImage imageNamed:@"slide_bar"] forState:UIControlStateNormal];
        
    }
    return self;
}

// 返回滑块大小
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    rect.origin.x = rect.origin.x - 2;
    rect.size.width = rect.size.width + 4;
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 2 , 2);
}

// 控制slider的宽和高
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

@end

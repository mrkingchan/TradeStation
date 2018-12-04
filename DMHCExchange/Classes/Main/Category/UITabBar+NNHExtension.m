//
//  UITabBar+NNHExtension.m
//  DMHCAMU
//
//  Created by 来旭磊 on 2017/4/17.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

#import "UITabBar+NNHExtension.h"

static NSInteger const badegIndex = 1;

@implementation UITabBar (NNHExtension)

- (void)showBadge
{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:badegIndex];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 10010 + badegIndex;
    badgeView.layer.cornerRadius = 5;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (badegIndex +0.6) / 3;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);
    [self addSubview:badgeView];
    [self bringSubviewToFront:badgeView];
}

- (void)hideBadge
{
    //移除小红点
    [self removeBadgeOnItemIndex:badegIndex];
}

- (void)removeBadgeOnItemIndex:(int)index{
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 10010+badegIndex) {
            
            [subView removeFromSuperview];
            
        }
    }
}


@end

//
//  NNHRefreshHeader.m
//  NNHPlatform
//
//  Created by 牛牛 on 2017/3/6.
//  Copyright © 2017年 Smile intl. All rights reserved.
//

#import "NNRefreshHeader.h"

@implementation NNRefreshHeader

/**
 *  初始化
 */
- (void)prepare
{
    [super prepare];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
//    self.lastUpdatedTimeLabel.hidden = YES;

}

@end

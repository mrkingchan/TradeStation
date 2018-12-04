//
//  NNHRefreshFooter.m
//  NNHPlatform
//
//  Created by 牛牛 on 2017/3/6.
//  Copyright © 2017年 Smile intl. All rights reserved.
//

#import "NNRefreshFooter.h"

@implementation NNRefreshFooter

- (void)prepare
{
    [super prepare];
    
    self.triggerAutomaticallyRefreshPercent = 0.2;
    
    self.stateLabel.hidden = YES;
    
    self.refreshingTitleHidden = YES;
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    if (state == MJRefreshStateRefreshing) {
        
        // 正在刷新过程中
        self.mj_h = 44;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self executeRefreshingCallback];
        });
    } else if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        
        // 无数据／闲置状态
        self.mj_h = 0.0;
        
        if (MJRefreshStateRefreshing == oldState) {
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }
    }
}

@end

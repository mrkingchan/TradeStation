//
//  NNHCycleScrollView.m
//  NNHPlatform
//
//  Created by 牛牛 on 2017/3/6.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

#import "NNHCycleScrollView.h"

@implementation NNHCycleScrollView

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<SDCycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage
{
    NNHCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.delegate = delegate;
    cycleScrollView.autoScrollTimeInterval = 5.0;
    cycleScrollView.placeholderImage = placeholderImage;
    cycleScrollView.backgroundColor = [UIConfigManager colorThemeColorForVCBackground];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.pageControlDotSize = CGSizeMake(6, 6);
    cycleScrollView.pageControlBottomOffset = 3;
    cycleScrollView.currentPageDotColor = [UIConfigManager colorThemeRed];
    cycleScrollView.pageDotColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    
    return cycleScrollView;
}


@end

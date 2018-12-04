//
//  NNHPageTitleView.h
//  NNHPlatform
//
//  Created by 来旭磊 on 2018/1/12.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NNHPageTitleView;

typedef enum : NSUInteger {
    NNHIndicatorTypeDefault, /// 指示器默认长度与按钮宽度相等
    NNHIndicatorTypeEqual, /// 指示器宽度等于按钮文字宽度
} NNHIndicatorType;

@protocol NNHPageTitleViewDelegate <NSObject>
/// delegatePageTitleView
- (void)nnh_pageTitleView:(NNHPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex;

@end

@interface NNHPageTitleView : UIView
/**
 *  对象方法创建 SGPageTitleView
 *
 *  @param frame     frame
 *  @param delegate     delegate
 *  @param titleNames     标题数组
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<NNHPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames;
/**
 *  类方法创建 SGPageTitleView
 *
 *  @param frame     frame
 *  @param delegate     delegate
 *  @param titleNames     标题数组
 */
+ (instancetype)pageTitleViewWithFrame:(CGRect)frame delegate:(id<NNHPageTitleViewDelegate>)delegate titleNames:(NSArray *)titleNames;


/** 普通状态标题文字颜色，默认黑色 */
@property (nonatomic, strong) UIColor *titleColorStateNormal;
/** 选中状态标题文字颜色，默认红色 */
@property (nonatomic, strong) UIColor *titleColorStateSelected;
/** 普通状态标题文字字体，默认13 */
@property (nonatomic, strong) UIFont *titleFont;
/** 指示器颜色，默认红色 */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 选中的按钮下标, 如果这个属性和 indicatorStyle 属性同时存在，则此属性在前 */
@property (nonatomic, assign) NSInteger selectedIndex;
/** 指示器样式 */
@property (nonatomic, assign) NNHIndicatorType indicatorStyle;

/** 是否加动画 */
@property (nonatomic, assign) BOOL indicatorAnimation;

/** 是否让标题有渐变效果，默认为 YES */
@property (nonatomic, assign) BOOL isTitleGradientEffect;
/** 是否让指示器滚动，默认为跟随内容的滚动而滚动 */
@property (nonatomic, assign) BOOL isIndicatorScroll;
/** 是否显示指示器，默认为 YES */
@property (nonatomic, assign) BOOL isShowIndicator;
/** 是否需要弹性效果，默认为 YES */
@property (nonatomic, assign) BOOL isNeedBounces;

/** 给外界提供的方法，获取 SGContentView 的 progress／originalIndex／targetIndex, 必须实现 */
- (void)setPageTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;

@end

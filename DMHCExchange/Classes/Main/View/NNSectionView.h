//
//  NNHSectionView.h
//  ElegantLife
//
//  Created by 牛牛 on 16/8/12.
//  Copyright © 2016年 NNH. All rights reserved.
//  tableview的分区view

#import <UIKit/UIKit.h>

@interface NNSectionView : UIView

/** 背景颜色 */
@property (nonatomic, strong) UIColor *sectionViewBackgroundColor;

/** 文字 */
@property (nonatomic, copy) NSString *text;
/** 文字颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 文字大小 */
@property (nonatomic, strong) UIFont *titleLabelTextFont;

/** 详细文字 */
@property (nonatomic, copy) NSString *detailText;
/** 详细文字(富文本) */
@property (nonatomic, copy) NSAttributedString *detailAttributedText;
/** 右边图片 */
@property (nonatomic, copy) NSString *rightImage;
/** 详细文字颜色 */
@property (nonatomic, strong) UIColor *detailTitleColor;
/** 详细文字大小 */
@property (nonatomic, strong) UIFont *detailTitleLabelTextFont;

/** 分割线颜色 */
@property (nonatomic, strong) UIColor *sectionViewLineColor;
/** 分割线颜色 默认0.5 */
@property (nonatomic, assign) CGFloat sectionViewLineHeight;
/** 是否显示箭头 默认YES */
@property (nonatomic, assign) BOOL showArrow;
/** 是否显示分割线 默认YES */
@property (nonatomic, assign) BOOL showLine;


/** 点击方法 */
@property (nonatomic, copy) void (^didSelectedViewAction)(void);


+ (instancetype)sectionIcon:(NSString *)icon title:(NSString *)title detailTile:(NSString *)detailTitle;
+ (instancetype)sectionTitle:(NSString *)title detailTile:(NSString *)detailTitle;


@end

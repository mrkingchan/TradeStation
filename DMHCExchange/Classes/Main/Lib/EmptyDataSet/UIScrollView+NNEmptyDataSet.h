//
//  UIScrollView+NNEmptyDataSet.h
//  NNHPlatform
//
//  Created by 牛牛 on 2017/6/30.
//  Copyright © 2017年 Smile intl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

typedef void(^ClickBlock)(void);

@interface UIScrollView (NNEmptyDataSet) <DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic) ClickBlock clickBlock;                // 点击事件
@property (nonatomic, assign) CGFloat emptyOffset;          // 垂直偏移量
@property (nonatomic, strong) NSString *emptyText;          // 空数据显示内容
@property (nonatomic, strong) NSString *emptySubText;       // 空数据显示子内容
@property (nonatomic, strong) NSString *emptyButtonTitle;   // 空数据按钮内容
@property (nonatomic, strong) UIImage *emptyImage;          // 空数据的图片

- (void)setupEmptyDataText:(NSString *)text tapBlock:(ClickBlock)clickBlock;
- (void)setupEmptyDataText:(NSString *)text emptySubText:(NSString *)subText tapBlock:(ClickBlock)clickBlock;
- (void)setupEmptyDataText:(NSString *)text emptyImage:(UIImage *)image tapBlock:(ClickBlock)clickBlock;

@end

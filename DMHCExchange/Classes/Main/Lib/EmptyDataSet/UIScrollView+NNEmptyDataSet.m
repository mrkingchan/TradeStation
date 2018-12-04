//
//  UIScrollView+NNEmptyDataSet.m
//  NNHPlatform
//
//  Created by 牛牛 on 2017/6/30.
//  Copyright © 2017年 Smile intl. All rights reserved.
//

#import "UIScrollView+NNEmptyDataSet.h"
#import <objc/runtime.h>

static const void *KClickBlock = @"clickBlock";
static const void *KEmptyText = @"emptyText";
static const void *KEmptySubText = @"emptySubText";
static const void *KEmptyButtonTitle = @"emptyButtonTitle";
static const void *KEmptyOffset = @"emptyOffset";
static const void *Kimage = @"emptyImage";

@implementation UIScrollView (NNEmptyDataSet)

#pragma mark - Getter Setter

- (ClickBlock)clickBlock{
    return objc_getAssociatedObject(self, &KClickBlock);
}

- (void)setClickBlock:(ClickBlock)clickBlock{
    
    objc_setAssociatedObject(self, &KClickBlock, clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)emptyText{
    return objc_getAssociatedObject(self, &KEmptyText);
}

- (void)setEmptyText:(NSString *)emptyText{
    objc_setAssociatedObject(self, &KEmptyText, emptyText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)emptySubText{
    return objc_getAssociatedObject(self, &KEmptySubText);
}

- (void)setEmptySubText:(NSString *)emptySubText{
    objc_setAssociatedObject(self, &KEmptySubText, emptySubText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)emptyButtonTitle{
    return objc_getAssociatedObject(self, &KEmptyButtonTitle);
}

- (void)setEmptyButtonTitle:(NSString *)emptyButtonTitle{
    objc_setAssociatedObject(self, &KEmptyButtonTitle, emptyButtonTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)emptyOffset{
    
    NSNumber *number = objc_getAssociatedObject(self, &KEmptyOffset);
    return number.floatValue;
}

- (void)setEmptyOffset:(CGFloat)emptyOffset{
    
    NSNumber *number = [NSNumber numberWithDouble:emptyOffset];
    objc_setAssociatedObject(self, &KEmptyOffset, number, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (UIImage *)emptyImage{
    return objc_getAssociatedObject(self, &Kimage);
}

- (void)setEmptyImage:(UIImage *)emptyImage{
    objc_setAssociatedObject(self, &Kimage, emptyImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (void)setupEmptyDataText:(NSString *)text tapBlock:(ClickBlock)clickBlock{
    
    self.clickBlock = clickBlock;
    self.emptyText = text;
    
    self.emptyDataSetSource = self;
    if (clickBlock) {
        self.emptyDataSetDelegate = self;
    }
}

- (void)setupEmptyDataText:(NSString *)text emptySubText:(NSString *)subText tapBlock:(ClickBlock)clickBlock
{
    self.clickBlock = clickBlock;
    self.emptyText = text;
    self.emptySubText = subText;
    
    self.emptyDataSetSource = self;
    if (clickBlock) {
        self.emptyDataSetDelegate = self;
    }
}

- (void)setupEmptyDataText:(NSString *)text emptyImage:(UIImage *)image tapBlock:(ClickBlock)clickBlock{
    
    self.emptyText = text;
    self.emptyImage = image;
    self.clickBlock = clickBlock;
    
    self.emptyDataSetSource = self;
    if (clickBlock) {
        self.emptyDataSetDelegate = self;
    }
}


#pragma mark - DZNEmptyDataSetSource
// 空白界面的标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = self.emptyText ? self.emptyText : @"没有找到任何数据";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIConfigManager colorThemeDark]};
    
    return [[NSAttributedString alloc] initWithString:text
                                           attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.emptySubText) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12.0f],
                                     NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        
        return [[NSAttributedString alloc] initWithString:self.emptySubText attributes:attributes];
    }else{
        return nil;
    }
    
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    if (self.emptyButtonTitle) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                     NSForegroundColorAttributeName: [UIColor whiteColor]};
        
        return [[NSAttributedString alloc] initWithString:self.emptyButtonTitle attributes:attributes];
    }else{
        return nil;
    }
    
}

// 空白页的图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return self.emptyImage ? self.emptyImage : [UIImage imageNamed:@"mine"];
}

//是否允许滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return self.emptyButtonTitle ? [UIImage imageNamed:@"empty_button"] : nil;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIConfigManager colorThemeColorForVCBackground];
}

// 垂直偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return self.emptyOffset != 0.0 ? self.emptyOffset : -scrollView.frame.size.height *0.5 *0.5;    
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20;
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView
{
    scrollView.contentOffset = CGPointZero;
}

#pragma mark - DZNEmptyDataSetDelegate
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end

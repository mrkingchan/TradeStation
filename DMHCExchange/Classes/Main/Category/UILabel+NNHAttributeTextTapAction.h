//
//  UILabel+NNHAttributeTextTapAction.h
//  DMHCAMU
//
//  Created by leiliao lai on 17/2/28.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           UILabel添加点击效果
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import <UIKit/UIKit.h>

@protocol NNHAttributeTapActionDelegate <NSObject>
@optional
/**
 *  NNHAttributeTapActionDelegate
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index 点击的字符在数组中的index
 */
- (void)nnh_attributeTapReturnString:(NSString *)string
                              range:(NSRange)range
                              index:(NSInteger)index;
@end

@interface NNHAttributeModel : NSObject

@property (nonatomic, copy) NSString *str;

@property (nonatomic, assign) NSRange range;

@end


@interface UILabel (NNHAttributeTextTapAction)

/**
 *  是否打开点击效果，默认是打开
 */
@property (nonatomic, assign) BOOL enabledTapEffect;

/**
 *  给文本添加点击事件Block回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param tapClick 点击事件回调
 */
- (void)nnh_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                 tapClicked:(void (^) (NSString *string , NSRange range , NSInteger index))tapClick;

/**
 *  给文本添加点击事件delegate回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param delegate delegate
 */
- (void)nnh_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                   delegate:(id <NNHAttributeTapActionDelegate> )delegate;

@end

//
//  NNHFontProtocol.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/18.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NNHFontProtocol <NSObject>


#pragma mark -
#pragma mark --------- 是 @"STHeitiSC-Light"  iOS9之前的默认字体
/** 所有方法都要以font开头哦 **/
/** 为了去掉消息转发时候的warning 才写optional 其实是requeired **/

@optional

#pragma mark -
#pragma mark ---------设计稿的字体
/** 少数重要标题（资讯详情等等 20） **/
- (UIFont *)fontThemeMostImportantTitles;
/** 少数大按钮的中文字 (如确定、确认订单、提交等  17) **/
- (UIFont *)fontThemeLargerBtnTitles;
/** 较为重要的文字 如分类名称 价格等 (15)**/
- (UIFont *)fontThemeTextImportant;
/** 正文字体 用于标题 价格 小按钮title等 (14) **/
- (UIFont *)fontThemeTextMain;
/** 大部分次要文字、提示性字体 (13)**/
- (UIFont *)fontThemeTextDefault;
/** 辅助性提示文字 (如副标语、提示 12)**/
- (UIFont *)fontThemeTextTip;
/** 辅助性提示文字 (如时间显示 11)**/
- (UIFont *)fontThemeTextMinTip;


#pragma mark -
#pragma mark ---------NavigationBar
/** 导航标题 **/
- (UIFont *)fontNaviTitle;
/** 导航按钮图片下面的小字体 **/
- (UIFont *)fontNaviBarButtonTitle;


@end

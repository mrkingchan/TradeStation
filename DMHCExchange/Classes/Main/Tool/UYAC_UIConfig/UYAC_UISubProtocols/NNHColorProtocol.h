//
//  NNHColorProtocol.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/18.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NNHColorProtocol <NSObject>


/** 所有函数都要以color开头哦 **/
/** 为了去掉消息转发时候的warning 才写optional 其实是requeired **/

@optional

#pragma mark -
#pragma mark ---------来自设计稿的 背景 主题色
/** 背景主题 **/
- (UIColor *)colorThemeBackground;
/** 主题黑色蒙版色 **/
- (UIColor *)colorThemeMaskBlack;
/** 分割线颜色 **/
- (UIColor *)colorThemeSeperatorLightGray;
/** 系统分割线颜色 **/
- (UIColor *)colorThemeSeperatorDarkGray;
/** 描边 **/
- (UIColor *)colorThemeColorStroke;
/** VC背景色 **/
- (UIColor *)colorThemeColorForVCBackground;

#pragma mark -
#pragma mark ---------来自设计稿的 字体 主题色
/** 主色调 红色  **/
- (UIColor *)colorThemeRed;
/** 主色调 深黑色 **/
- (UIColor *)colorThemeDark;
/** 主色调 黑色  **/
- (UIColor *)colorThemeBlack;
/** 主色调 白色  **/
- (UIColor *)colorThemeWhite;
/** 主色调 深灰色  **/
- (UIColor *)colorThemeDarkGray;
/** 次要文字(小提示，日期颜色) #858080 **/
- (UIColor *)colorTextLightGray;
/** #5a667e **/
- (UIColor *)colorThemeLightBlue;


#pragma mark -
#pragma mark ---------Navigation
/** 导航栏颜色 **/
- (UIColor *)colorNaviBarBgColor;
/** 导航title颜色 **/
- (UIColor *)colorNaviBarTitle;


#pragma mark -
#pragma mark ---------操作按钮
/** 操作按钮－#c6a351 **/
- (UIColor *)colorGoldOperation;
/** 操作按钮－#393945 **/
- (UIColor *)colorBlueOperation;
/** 不可用属性颜色 **/
- (UIColor *)colorThemeDisable;


#pragma mark -
#pragma mark ---------TabBar
/** TabBar颜色 **/
- (UIColor *)colorTabBarBgColor;
/** TabBar title颜色 **/
- (UIColor *)colorTabBarTitleDefault;
/** TabBar title高亮颜色 **/
- (UIColor *)colorTabBarTitleHeight;


@end

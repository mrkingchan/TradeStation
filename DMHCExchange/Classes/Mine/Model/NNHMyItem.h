//
//  NNHMyItem.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/23.
//  Copyright © 2016年 Smile intl. All rights reserved.
//  一个模型来描述cell每行的信息：图标、标题、右边内容（箭头，文字，开关等）

typedef NS_ENUM(NSInteger, NNHItemAccessoryViewType) {
    NNHItemAccessoryViewTypeNormal,   // 右边无内容
    NNHItemAccessoryViewTypeArrow,    // 右边显示箭头
    NNHItemAccessoryViewTypeRightLabel,  // 右边显示Label
    NNHItemAccessoryViewTypeSwitch,  // 右边显示开关
    NNHItemAccessoryViewTypeRightView,  // 右边显示箭头➕内容 / 箭头➕图片
    NNHItemAccessoryViewTypeCustomView,  // 右边自定义view
};

#import <Foundation/Foundation.h>

@interface NNHMyItem : NSObject

@property (nonatomic, copy) NSString *icon; /**< 图标*/
@property (nonatomic, copy) NSString *title; /**< 标题*/
@property (nonatomic, copy) NSString *rightTitle; /**< 当右边显示标题时 赋值*/
@property (nonatomic, copy) NSString *rightIcon; /**< 当右边显示小图标时 赋值*/
@property (nonatomic, strong) UIView *customRightView; /**< 自定义右边view */

@property (nonatomic, strong) UIColor *titleColor; /**< 标题颜色*/
@property (nonatomic, strong) UIFont *titleFont; /**< 标题字体*/
@property (nonatomic, strong) UIColor *rightTitleColor;/**< 右标题颜色*/

@property (nonatomic, assign) Class destVcClass; /**< 点击这行cell，需要调转到哪个控制器 */
@property (nonatomic, copy) void (^operation)(void); /**< 封装点击这行cell想做的事情 */
@property (nonatomic, assign) NNHItemAccessoryViewType type; /**< 风格*/

/** 适用于以方格排列的形式 */
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;

/** 适用于以条形排列的形式 */
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon itemAccessoryViewType:(NNHItemAccessoryViewType)type;
+ (instancetype)itemWithTitle:(NSString *)title itemAccessoryViewType:(NNHItemAccessoryViewType)type;

@end

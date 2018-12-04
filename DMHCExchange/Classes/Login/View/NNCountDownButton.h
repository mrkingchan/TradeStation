//
//  NNCountDownButton.h
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/16.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNCountDownButton : UIButton

/** 背景 */
@property (nonatomic, strong) UIColor *bgNormalColor;
@property (nonatomic, strong) UIColor *bgCountingColor;

/** 字体 */
@property (nonatomic, strong) UIColor *lbNormalColor;
@property (nonatomic, strong) UIColor *lbCountingColor;

/** 菊花颜色 */
@property (nonatomic, strong) UIColor *activityColor;

/** 当前数值 **/
@property (nonatomic, assign) NSUInteger curSec;
/** 计时长度**/
@property (nonatomic, assign) NSUInteger totalSec;

/** 辅助属性 通知点击了按钮调用者处理其他事情 */
@property (nonatomic, copy) void (^clickButtonBlock)(void);

/** 是否显示滑动验证 **/
@property (nonatomic, assign, getter=isSlideCapchaView) BOOL slideCapchaView;

- (instancetype)initWithTotalTime:(NSUInteger)totalTime titleBefre:(NSString *)titleBefore titleConting:(NSString *)titleCounting titleAfterCounting:(NSString *)titleAfter clickAction:(void(^)(NNCountDownButton *countBtn))clickAction;

- (void)startCounting;
- (void)resetButton;

@end

//
//  NNSlideCapchaView.h
//  DMHCExchange
//
//  Created by 牛牛 on 2018/11/5.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWSlideCaptchaView.h"

@interface NNSlideCapchaView : UIView

/// 滑块验证码view
@property (nonatomic ,strong) DWSlideCaptchaView *captchaView;

/** 验证回调 */
@property (nonatomic ,copy) void (^indentifyCompletion)(BOOL success);

/** 显示滑动验证码 */
- (void)showSlideCapchaView;

@end

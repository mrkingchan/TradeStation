//
//  NNHEnterPasswordView.h
//  WBTMall
//
//  Created by 来旭磊 on 17/4/7.
//  Copyright © 2017年 牛牛汇. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           弹出只输入资金密码
 
 @Remarks          <#注释#>
 
 *****************************************************/
#import <UIKit/UIKit.h>

@interface NNHEnterPasswordView : UIView

/**
 弹出支付控件
 
 @param fatherView 支付控件的父控件 最好是当前控制器的导航控制器
 */
- (void)showInFatherView:(UIView *)fatherView;

/** 输入资金密码 */
@property (nonatomic, copy) void(^didEnterCodeBlock)(NSString *password);

- (void)dissmissWithCompletion:(void (^)(void))completion;

/** 重新设置状态 */
- (void)resetStatus;

@end

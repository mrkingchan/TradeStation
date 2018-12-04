//
//  SVProgressHUD+NNHExtension.m
//  ElegantTrade
//
//  Created by 来旭磊 on 16/11/3.
//  Copyright © 2016年 牛牛汇. All rights reserved.
//

#import "SVProgressHUD+NNHExtension.h"

@implementation SVProgressHUD (NNHExtension)

#pragma mark --
#pragma makr -- 初始化属性
+ (void)initialize
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
    [SVProgressHUD setMinimumSize:CGSizeMake(120, 44)];
    [SVProgressHUD setBackgroundColor:[UIColor akext_colorWithHex:@"#555555"]];// 弹出框颜色
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]]; // 弹出框内容颜色
    [SVProgressHUD setCornerRadius:8.0];
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@""]];
}

#pragma mark --
#pragma makr -- 状态提示
+ (void)nn_showWithStatus:(NSString*)status
{
    [SVProgressHUD showWithStatus:status];
}

#pragma mark --
#pragma mark -- 文字提示
+ (void)showMessage:(NSString *)message
{
    [SVProgressHUD showSuccessWithStatus:message];
}

#pragma mark -- 
#pragma mark -- 关闭提示框
+ (void)nn_dismiss
{
    [SVProgressHUD dismiss];
}

+ (void)nn_dismissWithCompletion:(SVProgressHUDDismissCompletion)completion
{
    [SVProgressHUD dismissWithCompletion:completion];
}

+ (void)nn_dismissWithDelay:(NSTimeInterval)delay
{
    [SVProgressHUD dismissWithDelay:delay];
}

+ (void)nn_dismissWithDelay:(NSTimeInterval)delay completion:(SVProgressHUDDismissCompletion)completion
{
    [SVProgressHUD dismissWithDelay:delay completion:completion];
}

@end

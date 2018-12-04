//
//  NNHApplicationHelper.m
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/31.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import "NNHApplicationHelper.h"
#import "NNRealNameAuthenticationViewController.h"
#import "NNMineAccountSecurityViewController.h"
#import "UIViewController+NNHExtension.h"
#import "NNHAlertTool.h"
#import "NNAPIMineTool.h"
#import "NNHMyBankCardController.h"


@interface NNHApplicationHelper ()


@end

@implementation NNHApplicationHelper
NNHSingletonM

/** 打开系统设置 */
- (void)openApplcationSetting
{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark --
#pragma mark -- 打电话
- (void)openPhoneNum:(NSString *)phoneNum InView:(UIView *)view
{
    NSString *phoneStr = [[NSString alloc] initWithFormat:@"telprompt://%@",phoneNum];
    NSURL *phoneUrl = [NSURL URLWithString:phoneStr];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        }
    });
}

- (void)openQQWithQQNumber:(NSString *)qqNum
{
    NSURL *qqUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://wpa.b.qq.com/cgi/wpa.php?ln=2&uin=%@",qqNum]];
    if ([[UIApplication sharedApplication] canOpenURL:qqUrl]) {
        [[UIApplication sharedApplication] openURL:qqUrl];
    }
}

#pragma mark --
#pragma mark -- 实名认证

- (BOOL)isRealName
{
    NNUserModel *userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
    if ([userModel.isnameauth isEqualToString:@"1"]) {
        return YES;
    }else if ([userModel.isnameauth isEqualToString:@"2"]) {
        [SVProgressHUD showMessage:@"实名认证审核中"];
        return NO;
    }else{
        UIViewController *currentVC = [UIViewController currentViewController];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NNHAlertTool shareAlertTool] showAlertView:currentVC title:@"您还未实名认证，请完善实名认证！" message:nil cancelButtonTitle:@"取消" otherButtonTitle:@"去认证" confirm:^{
                NNRealNameAuthenticationViewController *vc = [[NNRealNameAuthenticationViewController alloc] init];
                [currentVC.navigationController pushViewController:vc animated:YES];
            } cancle:^{
                
            }];
        });
        return NO;
    }
}

#pragma mark --
#pragma mark -- 安全认证
- (BOOL)isSetupPayPassword
{
    NNUserModel *userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
    if ([userModel.payDec isEqualToString:@"1"]) {
        return YES;
    }else {
        UIViewController *currentVC = [UIViewController currentViewController];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NNHAlertTool shareAlertTool] showAlertView:currentVC title:@"您还未设置资金密码，请前往安全中心设置" message:nil cancelButtonTitle:@"取消" otherButtonTitle:@"确定" confirm:^{
                NNMineAccountSecurityViewController *vc = [[NNMineAccountSecurityViewController alloc] init];
                [currentVC.navigationController pushViewController:vc animated:YES];
            } cancle:^{
                
            }];
        });
        return NO;
    }
}

- (void)forgetPayPassword
{
    UIViewController *currentVC = [UIViewController currentViewController];
    NNMineAccountSecurityViewController *vc = [[NNMineAccountSecurityViewController alloc] init];
    [currentVC.navigationController pushViewController:vc animated:YES];
}

#pragma mark --
#pragma mark -- 版本更新
- (void)versionUpdate
{
    NNAPIMineTool *tool = [[NNAPIMineTool alloc] initVersionUpdate];
    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {

        // update 2强制 1有 0无 url 跳转的地址
        NSDictionary *data = responseDic[@"data"];
        if ([data[@"update"] integerValue] == 0) return;

        UIViewController *currentVC = [UIViewController currentViewController];
        [[NNHAlertTool shareAlertTool] showAlertView:currentVC
                                               title:data[@"title"]
                                             message:data[@"info"]
                                   cancelButtonTitle:[data[@"update"] integerValue] == 1 ? @"取消" : nil
                                    otherButtonTitle:@"去更新"
                                             confirm:^{

            NSURL *url = [NSURL URLWithString:data[@"url"]];
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {

                }];
            }else{
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }

        } cancle:^{

        }];

    } failBlock:^(NNHRequestError *error) {

    } isCached:NO];
}

#pragma mark --
#pragma mark -- 支付信息

/** 是否绑定银行卡 */
- (BOOL)isBindBankCard
{
    NNUserModel *userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
    
    if (![userModel.banknumber isEqualToString:@"0"]) {
        return YES;
    }else{
        UIViewController *currentVC = [UIViewController currentViewController];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NNHAlertTool shareAlertTool] showAlertView:currentVC title:@"您还未添加收款信息，请先完善收款信息！" message:nil cancelButtonTitle:@"取消" otherButtonTitle:@"去完善" confirm:^{
                NNHMyBankCardController *vc = [[NNHMyBankCardController alloc] init];
                [currentVC.navigationController pushViewController:vc animated:YES];
            } cancle:^{
                
            }];
        });
        return NO;
    }
}

#pragma mark --
#pragma mark -- 联系方式

/** 是否绑定手机号 */
- (BOOL)isBindMoible
{
    NNUserModel *userModel = [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel;
    
    if (userModel.mobile.length) {
        return YES;
    }else{
        UIViewController *currentVC = [UIViewController currentViewController];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NNHAlertTool shareAlertTool] showAlertView:currentVC title:@"您还未绑定手机号，请先绑定手机号！" message:nil cancelButtonTitle:@"取消" otherButtonTitle:@"去绑定" confirm:^{
                NNMineAccountSecurityViewController *vc = [[NNMineAccountSecurityViewController alloc] init];
                [currentVC.navigationController pushViewController:vc animated:YES];
            } cancle:^{
                
            }];
        });
        return NO;
    }
}

@end

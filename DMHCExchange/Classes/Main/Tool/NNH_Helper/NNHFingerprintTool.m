//
//  NNHFingerprintTool.m
//  NNHBitooex
//
//  Created by 牛牛 on 2018/3/23.
//  Copyright © 2018年 深圳市云牛惠科技有限公司. All rights reserved.
//

#import "NNHFingerprintTool.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "UIViewController+NNHExtension.h"
#import "NNHAlertTool.h"
#import "NNHApiLoginTool.h"

@implementation NNHFingerprintTool
NNHSingletonM

- (BOOL)openFingerprint
{
    return [[NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel.isfingerprint boolValue];
}

- (void)switchFingerprintStatus {
    __block BOOL fingerprintStatus = [[NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel.isfingerprint boolValue];
    NNHApiLoginTool *tool = [[NNHApiLoginTool alloc] initSwitchFingerprint];
    [tool nnh_StartRequestWithSucBlock:^(NSDictionary *responseDic) {
        fingerprintStatus = !fingerprintStatus;
        [NNHProjectControlCenter sharedControlCenter].userControl_currentUserModel.isfingerprint = [NSString stringWithFormat:@"%i",fingerprintStatus];
    } failBlock:^(NNHRequestError *error) {

    } isCached:NO];
}

- (void)openFingerprintResults:(void (^)(BOOL))results
{
    
    LAContext *context = [[LAContext alloc] init];
    
    // 是否显示输入密码 ""不显示
    context.localizedFallbackTitle = @"";
    
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        
        NSString *myLocalizedReasonString = @"轻触Home健验证已有手机指纹";
        NSString *localizedVerificationTitle = @"指纹";
        if (@available(iOS 11.0, *)) {
            if (context.biometryType == LABiometryTypeFaceID){
                myLocalizedReasonString = @"请验证面容 ID";
                localizedVerificationTitle = @"面容 ID";
            }
        }

        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError * _Nullable error) {

            dispatch_async(dispatch_get_main_queue(), ^{
                results(success);
            });
            
            if (error) {
                if (@available(iOS 11.0, *)) {
                    switch (error.code) {
                        case LAErrorAuthenticationFailed:// -1 连续三次指纹识别错误
                            [SVProgressHUD showMessage:[NSString stringWithFormat:@"%@不匹配",localizedVerificationTitle]];
                            break;
                        case LAErrorUserCancel:  // -2 在TouchID对话框中点击了取消按钮
                            NNHLog(@"用户取消验证");
                            break;
                        case LAErrorUserFallback:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"用户不使用TouchID/FaceID,选择手动输入密码");
                            });
                        }
                            break;
                        case LAErrorSystemCancel:// -4 TouchID对话框被系统取消，例如按下Home或者电源键
                            NNHLog(@"取消授权，如其他应用切入，用户自主");
                            break;
                        case LAErrorPasscodeNotSet:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID/FaceID 无法启动,因为用户没有设置密码");
                            });
                        }
                            break;
                        case LAErrorBiometryNotAvailable:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID/FaceID 无效");
                            });
                        }
                            break;
                        case LAErrorBiometryLockout:{ // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                            if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) { // 调起密码解锁
                                [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError * _Nullable error) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        results(success);
                                    });
                                }];
                            }else{
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    results(NO);
                                });
                            }
                        }
                            break;
                        case LAErrorAppCancel:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                            });
                        }
                            break;
                        case LAErrorInvalidContext:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                            });
                        }
                            break;
                        default:
                            break;
                    }
                } else {
                    
                    switch (error.code) {
                        case LAErrorAuthenticationFailed:// -1 连续三次指纹识别错误
                            [SVProgressHUD showMessage:@"指纹不匹配"];
                            break;
                        case LAErrorUserCancel:  // -2 在TouchID对话框中点击了取消按钮
                            NNHLog(@"用户取消验证Touch ID");
                            break;
                        case LAErrorUserFallback:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"用户不使用TouchID,选择手动输入密码");
                            });
                        }
                            break;
                        case LAErrorSystemCancel:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                            });
                        }
                            break;
                        case LAErrorPasscodeNotSet:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID 无法启动,因为用户没有设置密码");
                            });
                        }
                            break;
                        case LAErrorTouchIDNotAvailable:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID 无效");
                            });
                        }
                            break;
                        case LAErrorTouchIDLockout:{ // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                            if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) { // 调起密码解锁
                                [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"轻触Home健验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        results(success);
                                    });
                                }];
                            }else{
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    results(NO);
                                });
                            }
                        }
                            break;
                        case LAErrorAppCancel:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                            });
                        }
                            break;
                        case LAErrorInvalidContext:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                            });
                        }
                            break;
                        default:
                            break;
                    }
                    
                }
            }
        }];
        
    }else { //不支持
        
        NSString *myLocalizedReasonString = @"轻触Home健验证已有手机指纹";
        NSString *localizedVerificationTitle = @"指纹";
        if (@available(iOS 11.0, *)) {
            if (context.biometryType == LABiometryTypeFaceID){
                myLocalizedReasonString = @"请验证面容 ID";
                localizedVerificationTitle = @"面容 ID";
            }
        }
        
        if (@available(iOS 11.0, *)) {
            switch (error.code) {
                case LAErrorBiometryNotEnrolled:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NNHAlertTool shareAlertTool] showAlertView:[UIViewController currentViewController] title:@"你尚未设置面容 ID" message:nil cancelButtonTitle:nil otherButtonTitle:@"确定" confirm:^{
                            results(NO);
                        } cancle:^{
                            
                        }];
                    });
                }
                    break;
                case LAErrorBiometryLockout:{ // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) { // 调起密码解锁
                        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError * _Nullable error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                results(success);
                            });
                        }];
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            results(NO);
                        });
                    }
                }
                    break;
                default:
                    [SVProgressHUD showMessage:@"该设备不支持面容 ID"];
                    results(NO);
                    break;
            }
        }else {
            switch (error.code){
                case LAErrorTouchIDNotEnrolled:{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NNHAlertTool shareAlertTool] showAlertView:[UIViewController currentViewController] title:@"你尚未设置指纹" message:nil cancelButtonTitle:nil otherButtonTitle:@"确定" confirm:^{
                            results(NO);
                        } cancle:^{
                            
                        }];
                    });
                }
                    break;
                case LAErrorTouchIDLockout:{ // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) { // 调起密码解锁
                        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"轻触Home健验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                results(success);
                            });
                        }];
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            results(NO);
                        });
                    }
                }
                    break;
                default:
                    [SVProgressHUD showMessage:@"该设备不支持指纹"];
                    results(NO);
                    break;
            }
        }
    }
}
@end

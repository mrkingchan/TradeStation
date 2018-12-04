//
//  NNHApplicationHelper.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/31.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNHSingleton.h"
#import  <CoreLocation/CoreLocation.h>

@interface NNHApplicationHelper : NSObject
NNHSingletonH

#pragma mark --
#pragma mark -- 系统设置
- (void)openApplcationSetting;

#pragma mark --
#pragma mark -- QQ
- (void)openQQWithQQNumber:(NSString *)qqNum;

#pragma mark --
#pragma mark -- 打电话
- (void)openPhoneNum:(NSString *)phoneNum InView:(UIView *)view;


#pragma mark --
#pragma mark -- 身份认证
- (BOOL)isRealName;


#pragma mark --
#pragma mark -- 安全认证
/** 设置支付密码 */
- (BOOL)isSetupPayPassword;

/** 忘记支付密码 去找回 */
- (void)forgetPayPassword;


#pragma mark --
#pragma mark -- 版本更新
- (void)versionUpdate;

#pragma mark --
#pragma mark -- 支付信息

/** 是否绑定银行卡 */
- (BOOL)isBindBankCard;

#pragma mark --
#pragma mark -- 联系方式

/** 是否绑定手机号 */
- (BOOL)isBindMoible;


@end

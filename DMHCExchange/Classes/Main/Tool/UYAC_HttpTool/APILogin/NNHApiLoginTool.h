//
//  NNHApiLoginTool.h
//  NNHPlatform
//
//  Created by leiliao lai on 17/3/4.
//  Copyright © 2017年 Smile intl. All rights reserved.
//

#import "NNHBaseRequest.h"

@interface NNHApiLoginTool : NNHBaseRequest

/**
 注册国家手机号编码
 @return api
 */
- (instancetype)initCountryCodeData;


/**
 登录
 
 @param username 用户名 （必填）
 @param password 密码 （必填）
 @return 登录
 */
- (instancetype)initLoginWithUserName:(NSString *)username
                             password:(NSString *)password;


/**
 注册
 
 @param mobile 手机号 （必填）
 @param valicode 验证码 （必填）
 @param loginpwd 登录密码
 @param confirmpwd 确认密码
 @param parentid 引荐人id
 @param countryCode 国家编号
 @return 登录注册
 */
- (instancetype)initWithMobile:(NSString *)mobile
                      valicode:(NSString *)valicode
                      loginpwd:(NSString *)loginpwd
                    confirmpwd:(NSString *)confirmpwd
                      parentid:(NSString *)parentid
                   countryCode:(NSString *)countryCode
                    verifyType:(NNSecurityVerifyType)verifyType;


/**
 登录安全验证
 
 @param userName 用户名
 @param valicode 验证码
 @param cryptcode 加密串
 @return 登录注册
 */
- (instancetype)initWithLoginSecurityVerifyUserName:(NSString *)userName
                                          cryptcode:(NSString *)cryptcode
                                           valicode:(NSString *)valicode;


/**
 退出登录
 */
- (instancetype)initWithLogout;



/**
 指纹／面容 登录密码验证
 @param pwd 登录密码
 */

- (instancetype)initFingerprintVerificationWithPwd:(NSString *)pwd;


/**
 改变指纹状态
 
 */
- (instancetype)initSwitchFingerprint;


@end

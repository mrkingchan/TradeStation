//
//  NNHApiSecurityTool.h
//  NNHBitooex
//
//  Created by 来旭磊 on 2018/3/19.
//  Copyright © 2018年 深圳市云牛惠科技有限公司. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           安全中心相关api接口
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import "NNHBaseRequest.h"

@interface NNHApiSecurityTool : NNHBaseRequest

/**
 发送验证码
 
 @param mobile 手机号码
 @param type 验证码类型
 @return 实例对象
 */
- (instancetype)initWithMobile:(NSString *)mobile
                verifyCodeType:(NNHSendVerificationCodeType)type
                   countryCode:(NSString *)countryCode
                    verifyType:(NNSecurityVerifyType)verifyType;


/**
 重置密码短信验证
 
 @param verifyType 验证方式
 @param code 验证码
 @param codeType 验证码类型
 @return 实例对象
 */
- (instancetype)initResetPasswordValidationWithVerifyType:(NNSecurityVerifyType)verifyType
                                                     code:(NSString *)code
                                                 codeType:(NNHSendVerificationCodeType)codeType;

/**
 修改资金密码
 
 @return 实例对象
 */
- (instancetype)initUpdatePayPasswordWithPassword:(NSString *)password
                                          encrypt:(NSString *)encrypt
                                       verifyType:(NNSecurityVerifyType)verifyType;



/**
 修改登录密码
 
 @return 实例对象
 */
- (instancetype)initUpdateLoginPasswordWithPassword:(NSString *)password
                                         confirmpwd:(NSString *)confirmpwd
                                            encrypt:(NSString *)encrypt
                                         verifyType:(NNSecurityVerifyType)verifyType;


/**
 修改邮箱
 
 @return 实例对象
 */
- (instancetype)initUpdateEmailWithNewEmail:(NSString *)newEmail
                                   valicode:(NSString *)valicode
                                    encrypt:(NSString *)encrypt
                                 verifyType:(NNSecurityVerifyType)verifyType;


/**
 修改手机号码
 
 @return 实例对象
 */
- (instancetype)initUpdatePhoneWithMobile:(NSString *)mobile
                                 valicode:(NSString *)valicode
                                  encrypt:(NSString *)encrypt
                              countrycode:(NSString *)countrycode
                               verifyType:(NNSecurityVerifyType)verifyType;



/**
 找回密码
 
 @param username 账号
 @param valicode 验证码
 @return 实例对象
 */
- (instancetype)initForgotPasswordWithVerifyType:(NNSecurityVerifyType)verifyType
                                        username:(NSString *)username
                                        valicode:(NSString *)valicode
                                        loginpwd:(NSString *)loginpwd
                                      confirmpwd:(NSString *)confirmpwd;





@end

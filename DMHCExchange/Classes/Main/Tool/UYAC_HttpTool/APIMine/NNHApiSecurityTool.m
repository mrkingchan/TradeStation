//
//  NNHApiSecurityTool.m
//  NNHBitooex
//
//  Created by 来旭磊 on 2018/3/19.
//  Copyright © 2018年 深圳市云牛惠科技有限公司. All rights reserved.
//

#import "NNHApiSecurityTool.h"

@implementation NNHApiSecurityTool

- (instancetype)initWithMobile:(NSString *)mobile
                verifyCodeType:(NNHSendVerificationCodeType)type
                   countryCode:(NSString *)countryCode
                    verifyType:(NNSecurityVerifyType)verifyType
{
    self = [super init];
    if (self) {
        
        NSString *sendType = @"";
        if (type == NNHSendVerificationCodeType_userRegister) {
            sendType = @"register_";
        }else if (type == NNHSendVerificationCodeType_loginSecurityVerify) {
            sendType = @"safety_";
        }else if (type == NNHSendVerificationCodeType_changePayPassword) {
            sendType = @"update_pay_";
        }else if (type == NNHSendVerificationCodeType_userForgetpwd) {
            sendType = @"forget_loginpwd_";
        }else if (type == NNHSendVerificationCodeType_updatePhone){
            sendType = @"update_mobile_";
        }else if (type == NNHSendVerificationCodeType_phoneSecurityVerify){
            sendType = @"check_mobile_";
        }else if (type == NNHSendVerificationCodeType_updateEmail){
            sendType = @"update_email_";
        }else if (type == NNHSendVerificationCodeType_emailSecurityVerify){
            sendType = @"check_email_";
        }else if (type == NNHSendVerificationCodeType_withdrawCoin){
            sendType = @"myzc_";
        }else{
            sendType = @"update_loginpwd_";
        }
        
        if (!countryCode) {
            countryCode = @"";
        }
        
        if (verifyType == NNSecurityVerifyTypePhone) {
            self.requestReServiceType = @"user.public.sendvalicode";
            self.reAPIName = @"发送短信验证码";
            self.reParams = @{
                              @"mobile"         : mobile,
                              @"devicenumber"  :[[NNHProjectControlCenter sharedControlCenter].proConfig getUUId],
                              @"privatekey"     : [self md5WithCode:mobile],
                              @"sendType"       : sendType,
                              @"countrycode"    : countryCode,
                              };
        }else {
            self.requestReServiceType = @"user.public.sendemailvalicode";
            self.reAPIName = @"发送邮箱验证码";
            self.reParams = @{
                              @"email"         : mobile,
                              @"devicenumber"  :[[NNHProjectControlCenter sharedControlCenter].proConfig getUUId],
                              @"privatekey"     : [self md5WithCode:mobile],
                              @"sendType"       : sendType
                              };
        }
        
    }
    return self;
}

- (instancetype)initResetPasswordValidationWithVerifyType:(NNSecurityVerifyType)verifyType
                                                     code:(NSString *)code
                                                 codeType:(NNHSendVerificationCodeType)codeType
{
    self = [super init];
    if (self) {
        
        NSString *sourcetype = @"1";
        if (verifyType == NNSecurityVerifyTypeEmail) {
            sourcetype = @"2";
        }
        
        if (codeType == NNHSendVerificationCodeType_changePayPassword) {
            self.requestReServiceType = @"user.user.validpaypwd";
            self.reAPIName = @"校验修改支付密码验证码";
        }else if (codeType == NNHSendVerificationCodeType_phoneSecurityVerify) {
            self.requestReServiceType = @"user.user.validmobile";
            self.reAPIName = @"校验修改手机号码校验操作";
        }else if (codeType == NNHSendVerificationCodeType_emailSecurityVerify) {
            self.requestReServiceType = @"user.user.validemail";
            self.reAPIName = @"修改绑定邮箱证码校验";
        }else {
            self.requestReServiceType = @"user.user.validloginpwd";
            self.reAPIName = @"修改登录密码短信验证";
        }
        
        self.reParams = @{
                          @"valicode"   : [self md5WithCode:code],
                          @"sourcetype"  : sourcetype
                          };
    }
    return self;
}

/** 修改资金密码 */
- (instancetype)initUpdatePayPasswordWithPassword:(NSString *)password
                                          encrypt:(NSString *)encrypt
                                       verifyType:(NNSecurityVerifyType)verifyType
{
    self = [super init];
    if (self) {
        
        self.requestReServiceType = @"user.user.updatepaypwd";
        self.reAPIName = @"修改支付密码操作";
        
        NSString *sourcetype = @"1";
        if (verifyType == NNSecurityVerifyTypeEmail) {
            sourcetype = @"2";
        }
        
        self.reParams = @{
                          @"sourcetype" : sourcetype,
                          @"encrypt" : encrypt,
                          @"paypwd" : [password md5String]
                          };
    }
    return self;
}

- (instancetype)initUpdateLoginPasswordWithPassword:(NSString *)password
                                         confirmpwd:(NSString *)confirmpwd
                                            encrypt:(NSString *)encrypt
                                         verifyType:(NNSecurityVerifyType)verifyType
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"user.user.updateloginpwd";
        self.reAPIName = @"修改登录密码操作";
        
        NSString *sourcetype = @"1";
        if (verifyType == NNSecurityVerifyTypeEmail) {
            sourcetype = @"2";
        }
        
        self.reParams = @{
                          @"sourcetype" : sourcetype,
                          @"encrypt" : encrypt,
                          @"loginpwd" : [password md5String],
                          @"confirmpwd" : [confirmpwd md5String]
                          };
    }
    return self;
}

- (instancetype)initUpdateEmailWithNewEmail:(NSString *)newEmail
                                   valicode:(NSString *)valicode
                                    encrypt:(NSString *)encrypt
                                 verifyType:(NNSecurityVerifyType)verifyType
{
    if (self = [super init]) {
        self.requestReServiceType = @"user.user.updateemail";
        self.reAPIName = @"修改绑定邮箱";
        
        NSString *sourcetype = @"1";
        if (verifyType == NNSecurityVerifyTypeEmail) {
            sourcetype = @"2";
        }
        
        self.reParams = @{
                          @"email" : newEmail,
                          @"valicode" : [self md5WithCode:valicode],
                          @"sourcetype" : sourcetype,
                          @"encrypt" : encrypt
                          };
    }
    
    return self;
}

- (instancetype)initUpdatePhoneWithMobile:(NSString *)mobile
                                 valicode:(NSString *)valicode
                                  encrypt:(NSString *)encrypt
                              countrycode:(NSString *)countrycode
                               verifyType:(NNSecurityVerifyType)verifyType
{
    if (self = [super init]) {
        self.requestReServiceType = @"user.user.updatemobile";
        self.reAPIName = @"校修改用户手机号码操作";
        
        NSString *sourcetype = @"1";
        if (verifyType == NNSecurityVerifyTypeEmail) {
            sourcetype = @"2";
        }
        
        if (!countrycode) {
            countrycode = @"+86";
        }
        
        self.reParams = @{
                              @"valicode"   : [self md5WithCode:valicode],
                              @"mobile"  : mobile,
                              @"sourcetype" : sourcetype,
                              @"encrypt" : encrypt,
                              @"countrycode" :countrycode
                          };
    }
    return self;
}

- (instancetype)initForgotPasswordWithVerifyType:(NNSecurityVerifyType)verifyType
                                        username:(NSString *)username
                                        valicode:(NSString *)valicode
                                        loginpwd:(NSString *)loginpwd
                                      confirmpwd:(NSString *)confirmpwd
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"user.user.validforget";
        self.reAPIName = @"忘记密码";
        
        self.reParams = @{
                          @"username" : username,
                          @"valicode" : [self md5WithCode:valicode],
                          @"sourcetype" : verifyType == NNSecurityVerifyTypeEmail ? @"2" : @"1",
                          @"loginpwd" : [loginpwd md5String],
                          @"confirmpwd" : [confirmpwd md5String]
                          };
    }
    return self;
}

- (NSString *)md5WithCode:(NSString *)code
{
    NSString *string = [NSString stringWithFormat:@"%@%@",code,NNHAPI_PRIVATEKEY_IOS];
    return [string md5String];
}

@end

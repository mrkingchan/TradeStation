//
//  NNHApiLoginTool.m
//  NNHPlatform
//
//  Created by leiliao lai on 17/3/4.
//  Copyright © 2017年 Smile intl. All rights reserved.
//

#import "NNHApiLoginTool.h"

@implementation NNHApiLoginTool

/** 根据手机号获取登录验证码 */
- (instancetype)initWithMobile:(NSString *)mobile {
    self = [super init];
    if (self) {
        self.requestReServiceType = NNH_API_Login_GetLoginCode;
        self.reAPIName = @"根据手机号获取登录验证码";
        
        self.reParams = @{
                          @"mobile"       : mobile,
                          @"devicenumber" : [[NNHProjectControlCenter sharedControlCenter].proConfig getUUId],
                          @"privatekey"   : [self md5WithCode:mobile],
                          };
    }
    return self;
}

- (instancetype)initLoginWithUserName:(NSString *)username
                             password:(NSString *)password
{
    self = [super init];
    if (self) {
        self.requestReServiceType = NNH_API_NormalLogin;
        self.reAPIName = @"用户登录";
        
        self.reParams = @{
                          @"username" : username,
                          @"loginpwd" : [password md5String],
                          @"devtype"  : @"I"
                          };
    }
    return self;
}

- (instancetype)initWithMobile:(NSString *)mobile
                      valicode:(NSString *)valicode
                      loginpwd:(NSString *)loginpwd
                    confirmpwd:(NSString *)confirmpwd
                      parentid:(NSString *)parentid
                   countryCode:(NSString *)countryCode
                    verifyType:(NNSecurityVerifyType)verifyType
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"user.register.register";
        self.reAPIName = @"用户注册";
        
        if (!parentid) {
            parentid = @"";
        }
        
        if (!countryCode) {
            countryCode = @"+86";
        }
        
        if (verifyType == NNSecurityVerifyTypeEmail) {
            self.reParams = @{
                              @"devtype"        : @"I",
                              @"sourcetype"     : @"2",
                              @"email"          : mobile,
                              @"loginpwd"       : [loginpwd md5String],
                              @"confirmpwd"     : [confirmpwd md5String],
                              @"valicode"       : [self md5WithCode:valicode],
                              @"parentmobile"   : parentid
                              };
        }else {
            self.reParams = @{
                              @"devtype"        : @"I",
                              @"sourcetype"     : @"1",
                              @"mobile"         : mobile,
                              @"loginpwd"       : [loginpwd md5String],
                              @"confirmpwd"     : [confirmpwd md5String],
                              @"valicode"       : [self md5WithCode:valicode],
                              @"parentmobile"   : parentid,
                              @"countrycode"    : countryCode
                              };
        }
    }
    return self;
}

- (instancetype)initWithLoginSecurityVerifyUserName:(NSString *)userName
                                          cryptcode:(NSString *)cryptcode
                                           valicode:(NSString *)valicode
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"user.login.safetyvalicode";
        self.reAPIName = @"用户登录安全校验";
        self.reParams = @{
                          @"devtype"        : @"I",
                          @"username"       : userName,
                          @"cryptcode"      : cryptcode,
                          @"valicode"       : [self md5WithCode:valicode]
                          };
    }
    return self;
}

- (instancetype)initCountryCodeData
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"user.public.getcountrycode";
        self.reAPIName = @"获取国家代码";
    }
    return self;
}

- (instancetype)initWithLogout
{
    self = [super init];
    if (self) {
        self.requestReServiceType = NNH_API_NormalLogout;
        self.reAPIName = @"退出登录";
    }
    return self;
}

- (instancetype)initSwitchFingerprint
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"user.setting.updatefingerprintstatus";
        self.reAPIName = @"修改用户指纹状态";
    }
    return self;
}

- (instancetype)initFingerprintVerificationWithPwd:(NSString *)pwd
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"user.login.fingerprintlogin";
        self.reAPIName = @"指纹密码登录";
        self.reParams = @{
                          @"loginpwd"    : [pwd md5String]
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

//
//  NNHProjectControlCenter.m
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import "NNHProjectControlCenter.h"
#import "NNLoginViewController.h"

@interface NNHProjectControlCenter ()

@end

@implementation NNHProjectControlCenter

#pragma mark -
#pragma mark ---------  NNHLoginUserControlProcotol
/** 是否打开推送 **/
- (BOOL)openMessagePush
{
    return self.proConfig.isOpenMessage;
}

/** 是否已经登录 **/
- (BOOL)loginStatus:(BOOL)isJumpLogin {
    if (![self.userControl isLoginIn]){
        if (isJumpLogin) {
            [NNLoginViewController presentInViewController:[UIApplication sharedApplication].keyWindow.rootViewController completion:nil];
        }
        return NO;
    }else{
        return YES;
    }
}

/** 是否已经登录 跳到登录界面 带有回调的 **/
- (BOOL)loginStatus:(BOOL)isJumpLogin complete:(void(^)(void))complete {
    if (![self.userControl isLoginIn]){
        if (isJumpLogin) {
            [NNLoginViewController presentInViewController:[UIApplication sharedApplication].keyWindow.rootViewController completion:^{
                complete();
            }];
        }
        return NO;
    }else{
        return YES;
    }
}

/** 登录成功之后调用，保存用户资料 **/
- (void)userControl_saveUserDataWithUserInfo:(NNUserModel *)userModel
{
    [self.userControl saveUserDataWithUserInfo:userModel];
}

/** 返回当前登录用户资料，无则nil **/
- (NNUserModel *)userControl_currentUserModel
{
    return self.userControl.currentUserModel;
}

/** 把当前内存中已经登录的用户资料保存硬盘 **/
- (void)userControl_archiveCurrentUserToDisk
{
    [self.userControl archiveCurrentUserToDisk];
}

/** 补全账户信息存入本地 **/
- (void)completionUserModelWithDictionAry:(NSDictionary *)dic
{
    [self.userControl completionUserModelWithDictionAry:dic];
}

/** 删除本次登录用户文件 不是注销的时候不要调用 **/
- (void)userControl_removeCurrentLoginUserFile
{
    [self.userControl removeCurrentLoginUserFile];
}

#pragma mark -
#pragma mark --------- NNHProjectConfigProtocol
/** 是否是测试模式 **/
- (BOOL)Config_isTestMode
{
    return [NNHProjectConfig isTestMode];
}

#pragma mark --------- Private Methods
#pragma mark --------- NNHProjectConfigProtocol
/** 是否是测试模式 **/
- (BOOL)isTestMode
{
    return [NNHProjectConfig isTestMode];
}

/** 是否是第一次登录 **/
- (BOOL)isfirstLogin
{
    return self.proConfig.isfirstLogin;
}

- (void)setIsfirstLogin:(BOOL)isfirstLogin
{
    self.proConfig.isfirstLogin = isfirstLogin;
}

/** 获取屏幕大小 **/
- (NSString *)getDPIScreen
{
    return self.proConfig.getDPIScreen;
}

/** 获取当前应用版本**/
- (NSString *)currentVersion
{
    return self.proConfig.currentVersion;
}

/** 获取时间戳 **/
- (NSString *)getCurrentTimeMedicine
{
    return self.proConfig.getCurrentTimeMedicine;
}

/** 获取uuid **/
- (NSString *)getUUId
{
    return self.proConfig.getUUId;
}

/** 获取当前手机型号 **/
- (NSString *)getCurrentModel
{
    return self.proConfig.getCurrentModel;
}

- (NSString *)getNetWorkStates
{
    return self.proConfig.getNetWorkStates;
}


#pragma mark -
#pragma mark ---------Init Singelton
static id _instance = nil;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedControlCenter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark -
#pragma mark ---------新增加单例类需要在这里初始化
- (instancetype)init
{
    if (self = [super init]) {
        _userControl = [[NNHUserControl alloc] init];
        _proConfig = [[NNHProjectConfig alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}


@end

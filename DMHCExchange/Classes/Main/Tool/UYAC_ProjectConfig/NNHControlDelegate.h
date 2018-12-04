//
//  NNHControlDelegate.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNUserModel.h"

@protocol NNHLoginUserControlProcotol <NSObject>

/** 是否已经登录 跳到登录界面 **/
- (BOOL)loginStatus:(BOOL)isJumpLogin;
/** 是否已经登录 跳到登录界面 带有回调的 **/
- (BOOL)loginStatus:(BOOL)isJumpLogin complete:(void(^)(void))complete;
/** 登录成功之后调用，保存用户资料 **/
- (void)userControl_saveUserDataWithUserInfo:(NNUserModel *)user;
/** 补全账户信息存入本地 **/
- (void)completionUserModelWithDictionAry:(NSDictionary *)dic;
/** 返回当前登录用户资料，无则nil **/
- (NNUserModel *)userControl_currentUserModel;
/** 把当前内存中已经登录的用户资料保存硬盘 **/
- (void)userControl_archiveCurrentUserToDisk;
/** 删除本次登录用户文件 不是注销的时候不要调用 **/
- (void)userControl_removeCurrentLoginUserFile;

@end


@protocol NNHProjectConfigProtocol <NSObject>

/** 是否打开消息推送 **/
- (BOOL)openMessagePush;
/** 是否是测试模式 **/
- (BOOL)Config_isTestMode;
/** 获取当前应用版本**/
- (NSString *)currentVersion;

@end

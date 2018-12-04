//
//  NNHUserControl.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNHControlDelegate.h"

@interface NNHUserControl : NSObject

/** 当前登录用户**/
@property (nonatomic, strong, readonly) NNUserModel *currentUserModel;

/** 保存用户资料 **/
- (void)saveUserDataWithUserInfo:(NNUserModel *)userModel;

/** 补全账户信息存入本地 **/
- (void)completionUserModelWithDictionAry:(NSDictionary *)dic;

/** 把当前内存中已经登录的用户资料保存硬盘 **/
- (void)archiveCurrentUserToDisk;

/** 删除本次登录用户文件 不是注销的时候不要调用 **/
- (void)removeCurrentLoginUserFile;

/** 是否是已经登录的状态· **/
- (BOOL)isLoginIn;

/** 退出登录状态 **/
- (void)logOut;

/** 加载上次登录的用户信息 **/
- (NNUserModel *)loadLastLoginModelFromFile;

@end

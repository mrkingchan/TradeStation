//
//  NNHProjectConfig.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNHProjectConfig : NSObject

/** 是否是第一次登录 **/
@property (nonatomic, assign) BOOL isfirstLogin;
/** 是否打开消息提醒 **/
@property (nonatomic, assign, getter=isOpenMessage) BOOL openMessage;

/** 是否是测试模式 **/
+ (BOOL)isTestMode;
/** 获取屏幕大小 **/
- (NSString *)getDPIScreen;
/** 获取当前应用版本**/
- (NSString *)currentVersion;
/** 获取时间戳 **/
- (NSString *)getCurrentTimeMedicine;
/** 获取设备唯一标识 **/
- (NSString *)getUUId;
/** 获取手机型号 **/
- (NSString *)getCurrentModel;
/** 获取网络状态 **/
- (NSString *)getNetWorkStates;


#pragma mark --
#pragma mark -- 配置其他（第三方、网络等）
/** 配置IQKeyboardManager **/
- (void)setupIQKeyboardManager;
/** 配置友盟统计 */
- (void)startUMeng;
@end

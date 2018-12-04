//
//  NNHProjectConfig.m
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import "NNHProjectConfig.h"
#import "IQKeyboardManager.h"
#import "sys/utsname.h"
#import "AFNetworkReachabilityManager.h"

@implementation NNHProjectConfig

#pragma mark ------------------Propertylist
/** 是否是测试模式 **/
+ (BOOL)isTestMode
{
    return YES;
}

- (BOOL)isfirstLogin {
    // 先从沙盒读取上次的存储的版本号
    NSString *key = @"NewUserGuid";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    // 从plist文件中读取当前版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    
    if ([currentVersion isEqualToString:lastVersion]) {
        return NO;
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return YES;
    }
}

/** 获取屏幕大小 **/
- (NSString *)getDPIScreen
{
    NSString *DPI = [NSString stringWithFormat:@"%.0f*%.0f",SCREEN_WIDTH*2,SCREEN_HEIGHT*2];
    return DPI;
}

- (NSString *)currentVersion
{
    return [NSString stringWithFormat:@"%@", [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]];
}

- (NSString *)getCurrentTimeMedicine
{
    // 获取毫秒时间戳
    NSString *timeSp = [NSString nn_Timestamp];
    
    // 拼接4位随机数
    NSInteger num = (arc4random() % 10000);
    timeSp = [NSString stringWithFormat:@"%@%@",timeSp,[NSString stringWithFormat:@"%0.4ld",num]];
    return timeSp;
}

/** 是否打开消息提醒 **/
- (BOOL)isOpenMessage
{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    return UIUserNotificationTypeNone != setting.types ? YES : NO;
}

- (NSString *)getUUId
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStrRef= CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *retStr = [NSString stringWithString:(__bridge NSString *)uuidStrRef];
    CFRelease(uuidStrRef);
    return retStr;
}

- (NSString *)getNetWorkStates
{
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            return @"网络状态未知";
            break;
        case AFNetworkReachabilityStatusNotReachable:
            return @"无网络";
            break;
        case  AFNetworkReachabilityStatusReachableViaWWAN:
            return @"3G／4G";
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return @"WIFI";
            break;
        default:
            break;
    }
}

/** 获取手机型号 **/
- (NSString *)getCurrentModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6sPlus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceString;
}

/** 配置IQKeyboardManager **/
- (void)setupIQKeyboardManager
{
    IQKeyboardManager *manager =  [IQKeyboardManager sharedManager];
    manager.enable = YES;//是否启用键盘管理

    manager.shouldResignOnTouchOutside = YES;//点击可编辑之外，是否自动隐藏键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = YES;//控制是否显示键盘上的工具条
    manager.keyboardDistanceFromTextField = 20.f;
}

/** 配置友盟统计 */
- (void)startUMeng
{
//    UMConfigInstance.appKey = NNH_UMengAppKey;
//    
//    // 正式环境下 收集错误信息
//    if ([[NNHProjectControlCenter sharedControlCenter] Config_isTestMode]) {
//        [MobClick setCrashReportEnabled:NO];
//    }
//
//    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
}

@end

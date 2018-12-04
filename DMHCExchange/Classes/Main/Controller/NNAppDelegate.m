//
//  AppDelegate.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/2.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNAppDelegate.h"
#import "YTKNetworkConfig.h"
#import "NNTabBarController.h"
#import "NNHApplicationHelper.h"
#import "NNHFingerprintVerificationViewController.h"

#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <AdSupport/AdSupport.h>
#import "NNHAlertTool.h"
@interface NNAppDelegate () <JPUSHRegisterDelegate>
{
    NSDate *_enterBackGroundDate; // 进入后台时间
}

@end

@implementation NNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[NNTabBarController alloc] init];

    // 配置第三方
    [[NNHProjectControlCenter sharedControlCenter].proConfig setupIQKeyboardManager];
    //推送
    [self configurePushWithOptions:launchOptions];
    
    [self netWorkConfig];
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveCustomMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void)didRecieveCustomMessage:(NSNotification *)noti {
    if ([UIApplication sharedApplication].applicationState!=UIApplicationStateActive) {
     [self defalutEnterHomePage];
    }
   /*NSDictionary *messageInfo = noti.userInfo;
    NSLog(@"message = %@",messageInfo);
    if ([UIApplication sharedApplication].applicationState ==UIApplicationStateActive ) {
        [[NNHAlertTool shareAlertTool] showAlertView:[UIApplication sharedApplication].keyWindow.rootViewController title:[messageInfo mj_JSONString] message:@"" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" confirm:^{
            
        } cancle:^{
            
        }];
    }*/
}

-(void)configurePushWithOptions:(NSDictionary *)launchOptions {
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions
                           appKey:NNH_JPushKey
                          channel:@"App Store"
                 apsForProduction:DEBUG ? NO:YES
            advertisingIdentifier:@""];
}

- (void)netWorkConfig { // http://exapi.smilevip.net/ 国际版本   http://exapi.yunniuhui.cn/ 国内
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = [[NNHProjectControlCenter sharedControlCenter] Config_isTestMode] ? @"http://www.niuniuhuiapp.net:30988/" : @"http://exapi.yunniuhui.cn/";
    config.cdnUrl = [[NNHProjectControlCenter sharedControlCenter] Config_isTestMode] ? @"http://www.niuniuhuiapp.net:30987/" : @"http://exmobile.smilevip.net/";
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    _enterBackGroundDate = [NSDate date];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NNHApplicationHelper sharedInstance] versionUpdate];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if (![NNHProjectControlCenter sharedControlCenter].userControl.isLoginIn) return;
    
    // 验证
    if ([[NSDate date] timeIntervalSinceDate:_enterBackGroundDate] >= 300) {
     [self.window.rootViewController presentViewController:[NNHFingerprintVerificationViewController new] animated:YES completion:nil];
    }
}

#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    [self defalutEnterHomePage];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self defalutEnterHomePage];
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)defalutEnterHomePage {
    NNTabBarController *rootVC = (NNTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    rootVC.selectedIndex = 0;
}

@end

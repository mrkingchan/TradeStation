//
//  NNHNotificationName.h
//  NNHPlatform
//
//  Created by 牛牛 on 2017/2/28.
//  Copyright © 2017年 Smile intl. All rights reserved.
//
/*****************************************************
 
 @Author          牛牛
 
 @CreateTime      2017-2-28
 
 @Function        所有消息的推送名字
 
 @Remarks          nothing
 
 *****************************************************/

#import <Foundation/Foundation.h>

@interface NNNotificationName : NSObject


#pragma mark -
#pragma mark ---------支付
extern NSString * const NNH_NotificationPayTool_toAccountRecharge;
/** 支付去设置密码 **/
extern NSString * const NNH_NotificationPayTool_setupPayCode;
/** 支付去设置密码 **/
extern NSString * const NNH_NotificationPayTool_updatePayCode;


#pragma mark -
#pragma mark ---------其他
/** 返回首页 **/
extern NSString *const NNH_NotificationBackHome;

@end

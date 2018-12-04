//
//  NNHConst.m
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import "NNConst.h"

@implementation NNConst

#pragma mark -----
#pragma mark ----- 公用
/** 公用-间距-5 操作按钮左右间距 */
CGFloat const NNHMargin_5 = 5;
/** 公用-间距-10 */
CGFloat const NNHMargin_10 = 10;
/** 公用-间距-15 */
CGFloat const NNHMargin_15 = 15;
/** 公用-间距-20 */
CGFloat const NNHMargin_20 = 20;
/** 公用-间距-25 */
CGFloat const NNHMargin_25 = 25;
/** 公用-操作按钮高度（登录、确认等）- 44 */
CGFloat const NNHOperationButtonH = 44;
/** 公用-操作按钮圆角半径 */
CGFloat const NNHOperationButtonRadiu = 5.0;
/** 公用-所有头部、尾部View、单个Cell（详情等）- 44 */
CGFloat const NNHNormalViewH = 44;
/** 公用-所有分割线高度 - 0.5 */
CGFloat const NNHLineH = 0.5;
/** 雅活-顶部toolbar的高度 */
CGFloat const NNHTopToolbarH = 40;
/** 公用-键盘／选择器高度 */
CGFloat const NNHKeyboardHeight = 216;
/** 公用-按钮重复点击间隔 */
CGFloat const NNHAcceptEventInterval = 3;
/** 最大手机位数 */
CGFloat const NNHMaxPhoneLength = 12;
/** 最小手机位数 */
CGFloat const NNHMinPhoneLength = 6;
/** Smile intl版本接口 */
NSString *const NNHPort = @"I1.0.0";


#pragma mark -----
#pragma mark ----- 所用图比例


#pragma mark -----
#pragma mark ----- ShareSDK其他接口的appkey
/** ShareSDK-Appkey */
NSString *const NNH_ShareSDK_Appkey = @"24f3d98486b62";
/** ShareSDK-AppSecret */
NSString *const NNH_ShareSDK_AppSecret = @"77dc8a56b2b4ca2d4b0048480a45e0ea";
/** 微信、朋友圈AppID */
NSString *const NNH_ShareSDK_WEIXIN_APPID_INDEX = @"wx697208c902fa660d";
/** 微信、朋友圈SECRET */
NSString *const NNH_ShareSDK_WEIXIN_SECRET_INDEX = @"78d1df102e43c5376570f249fd43ff80";
/** 新浪微博-Appkey */
NSString *const NNH_ShareSDK_SinaWeiBo_AppKey = @"1543589403";
/** 新浪微博-AppSecret */
NSString *const NNH_ShareSDK_SinaWeiBo_AppSecret = @"b6538552fc0fa0d89f7ec546ce7933b3";
/** QQ-AppID */
NSString *const NNH_ShareSDK_QQ_AppID = @"1106734599";
/** QQ-AppKey */
NSString *const NNH_ShareSDK_QQ_AppKey = @"hNSRxdreJVu1NFvz";

/** 融云-AppKey开发环境 */
NSString *const NNH_RongCloud_Appkey_Develop = @"3argexb6342be";
/** 融云-AppKey正式环境 */
NSString *const NNH_RongCloud_Appkey = @"ik1qhw09i2u0p";
/** 融云-单聊消息 订单处理消息 */
NSString *const NNH_RongCloud_Message_OrderHandle = @"6bb61e3b7bce0931da574d19d1d82c88";
/** 融云-单聊消息 分润收益消息 */
NSString *const NNH_RongCloud_Message_Income = @"5d7b9adcbe1c629ec722529dd12e5129";
/** 融云-单聊消息 加油提现消息 */
NSString *const NNH_RongCloud_Message_RechargeOrWidth = @"b3149ecea4628efd23d2f86e5a723472";
/** 融云-单聊消息 系统消息 */
NSString *const NNH_RongCloud_Message_System = @"0267aaf632e87a63288a08331f22c7c3";
///** 融云-单聊消息 */
//NSString *const NNH_RongCloud_Appkey = @"3argexb6342be";

///** 极光推送 */
NSString *const NNH_JPushKey = @"f9877ae28ce88cfd27b6ea33";

#pragma mark -----
#pragma mark ----- 货币
/** Smile intl货币 */
NSString *const NNHCurrency = @"牛豆";


#pragma mark -----
#pragma mark ----- 项目安全相关
/** 私钥 */
NSString *const NNHAPI_PRIVATEKEY_IOS = @"b9490ed0933588e736612c7fbf2a3324";

#pragma mark -----
#pragma mark ----- 其他
/** 用户位置 属性列表保存字段  上次保存的城市名 */
NSString *const NNH_User_Location_lastSaveCityName = @"NNH_User_Location_lastSaveCityName";
NSString *const NNH_User_CurrentLocation_cityName = @"NNH_User_CurrentLocation_cityName";
/** 用户位置 属性列表保存字段  经度 */
NSString *const NNH_User_CurrentLocation_longitude = @"NNH_User_CurrentLocation_longitude";
/** 用户位置 属性列表保存字段  纬度 */
NSString *const NNH_User_CurrentLocation_latitude = @"NNH_User_CurrentLocation_latitude";
/** 保存用户当前城市id */
NSString *const NNH_User_CurrentLocation_cityID = @"NNH_User_CurrentLocation_cityID";
/** 保存推送的token */
NSString *const NNH_User_Device_push_token = @"NNH_User_Device_push_token";


@end

//
//  NNHConst.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/19.
//  Copyright © 2016年 Smile intl. All rights reserved.
//

#import <UIKit/UIKit.h>


/** 法币交易 交易记录类型 */
typedef NS_ENUM(NSInteger, NNLegalTenderTradeOrderListType) {
    NNLegalTenderTradeOrderListType_unfinished = 0,     // 未完成
    NNLegalTenderTradeOrderListType_end = 1,            // 已完成
    NNLegalTenderTradeOrderListType_cancle = 2,         // 已取消
};

typedef NS_ENUM(NSInteger, NNLegalTenderTradeType) {
    NNLegalTenderTradeType_buy     = 0,      // 法币交易 买入
    NNLegalTenderTradeType_sell  = 1,        // 法币交易 卖出
};

typedef NS_ENUM(NSInteger, NNLegalTenderTradePaymentType) {
    NNLegalTenderTradePaymentType_ali     = 0,      //支付宝
    NNLegalTenderTradePaymentType_wechat  = 1,      //微信
    NNLegalTenderTradePaymentType_bank  = 2,      // 银行卡
};

/** 账户安全验证方式  */
typedef NS_ENUM(NSInteger, NNSecurityVerifyType){
    NNSecurityVerifyTypePhone = 1,  // 手机验证
    NNSecurityVerifyTypeEmail = 2,  // 邮箱验证
};

/** 发送验证码type  */
typedef NS_ENUM(NSInteger, NNHSendVerificationCodeType){
    NNHSendVerificationCodeType_userRegister = 0,               // 注册发送验证码
    NNHSendVerificationCodeType_userForgetpwd = 1,              // 忘记密码
    NNHSendVerificationCodeType_changeLoginPassword = 2,        // 修改登录密码，发送验证码
    NNHSendVerificationCodeType_changePayPassword = 3,          // 修改资金密码，发送验证码
    NNHSendVerificationCodeType_updatePhone = 4,                // 更新手机号码，新手机发送验证码
    NNHSendVerificationCodeType_updateEmail = 5,                // 更新邮箱，新邮箱发送验证码
    NNHSendVerificationCodeType_loginSecurityVerify = 6,        // 登录安全验证
    NNHSendVerificationCodeType_emailSecurityVerify = 7,        // 修改邮箱安全验证，旧邮箱发送验证码
    NNHSendVerificationCodeType_phoneSecurityVerify = 8,        // 修改手机安全验证，旧手机发送验证码
    NNHSendVerificationCodeType_withdrawCoin = 9                // 币种提现
};

/** 用户资金操作type */
typedef NS_ENUM(NSInteger, NNHUserFundOperationType){
    NNHUserFundOperationType_default,                    // 不区分充提
    NNHUserFundOperationType_rechargeCoin,               // 充币
    NNHUserFundOperationType_withdrawCoin,               // 提币
    NNHUserFundOperationType_withdrawCNY                 // 提现人民币
};

/** 交易类型  */
typedef NS_ENUM(NSInteger, NNHCoinTradingOrderType){
    NNHCoinTradingOrderType_buyIn = 0,      // 买进
    NNHCoinTradingOrderType_soldOut = 1,    // 卖出
};

typedef NS_ENUM(NSInteger, NNHCoinTradingUnitType) {
    NNHCoinTradingUnitType_CNY     = 0,
    NNHCoinTradingUnitType_USDT  = 1,
};

@interface NNConst : NSObject

#pragma mark -----
#pragma mark ----- 公用
/** 公用-间距-5 操作按钮左右间距 */
UIKIT_EXTERN CGFloat const NNHMargin_5;
/** 公用-间距-10 */
UIKIT_EXTERN CGFloat const NNHMargin_10;
/** 公用-间距-15 */
UIKIT_EXTERN CGFloat const NNHMargin_15;
/** 公用-间距-20 */
UIKIT_EXTERN CGFloat const NNHMargin_20;
/** 公用-间距-25 */
UIKIT_EXTERN CGFloat const NNHMargin_25;
/** 公用-操作按钮高度（登录、确认等）- 40 */
UIKIT_EXTERN CGFloat const NNHOperationButtonH;
/** 公用-操作按钮圆角半径 */
UIKIT_EXTERN CGFloat const NNHOperationButtonRadiu;
/** 公用-所有头部、尾部View、单个Cell（详情等）- 44 */
UIKIT_EXTERN CGFloat const NNHNormalViewH;
/** 公用-所有分割线高度 - 0.5 */
UIKIT_EXTERN CGFloat const NNHLineH;
/** 公用-操作按钮圆角半径 */
UIKIT_EXTERN CGFloat const NNHOperationButtonRadiu;
/** 公用-顶部toolbar的高度 */
UIKIT_EXTERN CGFloat const NNHTopToolbarH;
/** 公用-顶部toolbar的Y */
UIKIT_EXTERN CGFloat const NNHTopToolbarY;
/** 公用-键盘／选择器高度 */
UIKIT_EXTERN CGFloat const NNHKeyboardHeight;
/** 公用-按钮重复点击间隔 */
UIKIT_EXTERN CGFloat const NNHAcceptEventInterval;
/** 最大手机位数 */
UIKIT_EXTERN CGFloat const NNHMaxPhoneLength;
/** 最小手机位数 */
UIKIT_EXTERN CGFloat const NNHMinPhoneLength;
/** Smile intl版本接口 */
UIKIT_EXTERN NSString *const NNHPort;


#pragma mark -----
#pragma mark ----- 所用图比例


#pragma mark -----
#pragma mark ----- 会员中心


#pragma mark -----
#pragma mark ----- ShareSDK其他接口的appkey
/** ShareSDK-Appkey */
UIKIT_EXTERN NSString *const NNH_ShareSDK_Appkey;
/** ShareSDK-AppSecret */
UIKIT_EXTERN NSString *const NNH_ShareSDK_AppSecret;
/** 微信、朋友圈AppID */
UIKIT_EXTERN NSString *const NNH_ShareSDK_WEIXIN_APPID_INDEX;
/** 微信、朋友圈SECRET */
UIKIT_EXTERN NSString *const NNH_ShareSDK_WEIXIN_SECRET_INDEX;
/** 新浪微博-Appkey */
UIKIT_EXTERN NSString *const NNH_ShareSDK_SinaWeiBo_AppKey;
/** 新浪微博-AppSecret */
UIKIT_EXTERN NSString *const NNH_ShareSDK_SinaWeiBo_AppSecret;
/** QQ-AppID */
UIKIT_EXTERN NSString *const NNH_ShareSDK_QQ_AppID;
/** QQ-AppKey */
UIKIT_EXTERN NSString *const NNH_ShareSDK_QQ_AppKey;

/** 融云-AppKey开发环境 */
UIKIT_EXTERN NSString *const NNH_RongCloud_Appkey_Develop;
/** 融云-AppKey */
UIKIT_EXTERN NSString *const NNH_RongCloud_Appkey;
/** 融云-单聊消息 订单处理消息 */
UIKIT_EXTERN NSString *const NNH_RongCloud_Message_OrderHandle;
/** 融云-单聊消息 分润收益消息 */
 UIKIT_EXTERN NSString *const NNH_RongCloud_Message_Income;
/** 融云-单聊消息 加油提现消息 */
UIKIT_EXTERN NSString *const NNH_RongCloud_Message_RechargeOrWidth;
/** 融云-单聊消息 系统消息 */
UIKIT_EXTERN NSString *const NNH_RongCloud_Message_System;

/** 极光推送key */
UIKIT_EXTERN NSString *const NNH_JPushKey;

#pragma mark -----
#pragma mark ----- 货币
/** Smile intl货币 */
UIKIT_EXTERN NSString *const NNHCurrency;


#pragma mark -----
#pragma mark ----- 项目安全相关
/** 私钥 */
UIKIT_EXTERN NSString *const NNHAPI_PRIVATEKEY_IOS;

#pragma mark -----
#pragma mark ----- 其他
/** 用户位置 属性列表保存字段  上次保存的城市名 */
UIKIT_EXTERN NSString *const NNH_User_Location_lastSaveCityName;
/** 用户位置 属性列表保存字段  当前城市 */
UIKIT_EXTERN NSString *const NNH_User_CurrentLocation_cityName;
/** 用户位置 属性列表保存字段  经度 */
UIKIT_EXTERN NSString *const NNH_User_CurrentLocation_longitude;
/** 用户位置 属性列表保存字段  纬度 */
UIKIT_EXTERN NSString *const NNH_User_CurrentLocation_latitude;
/** 保存用户当前城市id */
UIKIT_EXTERN NSString *const NNH_User_CurrentLocation_cityID;
/** 保存推送的token */
UIKIT_EXTERN NSString *const NNH_User_Device_push_token;

@end

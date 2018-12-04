//
//  NNHAPIInterfaceNames.h
//  ElegantTrade
//
//  Created by 张佩 on 16/10/24.
//  Copyright © 2016年 雅活荟. All rights reserved.
//

#ifndef NNHAPIInterfaceNames_h
#define NNHAPIInterfaceNames_h


/* -------------------------------------------------------------------------------- */
#pragma mark - 用户相关  用户资料、登录注册
/** 个人中心主页 **/
static NSString *const NNH_API_User_Index = @"user.index.main";
/** 我的二维码 **/
static NSString *const NNH_API_User_Mycode = @"user.index.push";
/** 获取手机号验证码 **/
static NSString *const NNH_API_Login_GetLoginCode = @"user.login.send";
/** 手机号验证码登陆 **/
static NSString *const NNH_API_NormalLogin = @"user.login.login";
/** 退出登录 **/
static NSString *const NNH_API_NormalLogout = @"user.login.signout";
/** 我的资料页面数据 **/
static NSString *const NNH_API_User_MyInfo = @"user.user.index";
/** 我的资料设置 **/
static NSString *const NNH_API_User_UpdateInfo = @"user.user.updateInfo";
/** 获取修改手机的短信验证码 **/
static NSString *const NNH_API_User_GetChangeMobile = @"user.user.send";
/** 修改手机号 **/
static NSString *const NNH_API_User_UpdatePhone = @"user.user.updatePhone";
/** 修改支付密码 **/
static NSString *const NNH_API_SetupPayCode = @"user.user.updatePayPwd";
/** 设置支付密码 **/
static NSString *const NNH_API_SetPayCode = @"user.user.setPay";

/** 收货地址列表 **/
static NSString *const NNH_API_User_LogisticsList = @"user.logistics.logisticsList";
/** 设置默认收货地址 **/
static NSString *const NNH_API_User_SetDefaultlogistic = @"user.logistics.setDefaultlogistic";
/** 添加收货地址 **/
static NSString *const NNH_API_User_AddCustomerLogistic = @"user.logistics.addCustomerLogistic";
/** 编辑收货地址 **/
static NSString *const NNH_API_User_UpdateCustomerLogistic = @"user.logistics.updateCustomerLogistic";
/** 删除收货地址 **/
static NSString *const NNH_API_User_DelCustomerLogistic = @"user.logistics.delCustomerLogistic";
/* -------------------------------------------------------------------------------- */


#pragma mark - 本地链接
/** 注册协议 **/
static NSString *const NNH_API_MemberAgreement = @"Introduction/Index/registDeal";

#endif /* NNHAPIInterfaceNames_h */

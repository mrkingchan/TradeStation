//
//  NNHUserModel.h
//  NNHPlatform
//
//  Created by 牛牛 on 2017/3/15.
//  Copyright © 2017年 Smile intl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNUserModel : NSObject <NSCoding>

/** 手机令牌 */
@property (nonatomic, copy) NSString *mtoken;
/** UID */
@property (nonatomic, copy) NSString *uid;
/** 账户 */
@property (nonatomic, copy) NSString *username;
/** 用户名 */
@property (nonatomic, copy) NSString *nickname;
/** 用户头像 */
@property (nonatomic, copy) NSString *headerpic;
/** 真实姓名 */
@property (nonatomic, copy) NSString *realname;
/** 是否实名认证 是否实名认证 1已认证 0未认证 2审核中 */
@property (nonatomic, copy) NSString *isnameauth;
/** 身份证号码 */
@property (nonatomic, copy) NSString *idnumber;
/** 是否设置收货地址 */
@property (nonatomic, copy) NSString *logisticsDec;
/** 用户手机 */
@property (nonatomic, copy) NSString *mobile;
/** 完整手机号 */
@property (nonatomic, copy) NSString *completemobile;
/** 邮箱 */
@property (nonatomic, copy) NSString *email;
/** 是否设置资金密码 */
@property (nonatomic, copy) NSString *payDec;
/** 是否设置登录密码(1是 0否) */
@property (nonatomic, copy) NSString *isloginpwd;
/** 银行卡信息数量 */
@property (nonatomic, copy) NSString *banknumber;
/** 国家地区 */
@property (nonatomic, copy) NSString *area;
/** 地区编码 */
@property (nonatomic, copy) NSString *area_code;
/** 是否设置了指纹 */
@property (nonatomic, copy) NSString *isfingerprint;

// 辅助属性
/** 验证方式 */
@property (nonatomic, strong) NSMutableDictionary *verifyTypeDic;

@end

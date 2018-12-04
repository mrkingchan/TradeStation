//
//  NNAPIMineTool.h
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/27.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNHBaseRequest.h"

@interface NNAPIMineTool : NNHBaseRequest

#pragma mark --
#pragma mark -- 会员数据
/** 获取个人中心数据 */
- (instancetype)initMemberDataSource;
/** 我的二维码 */
- (instancetype)initMyQrCode;
/** 关于我们 */
- (instancetype)initAbout;
/** 版本更新 */
- (instancetype)initVersionUpdate;
/** 返佣记录 */
- (instancetype)initBrokerageWithPage:(NSUInteger)page;


#pragma mark --
#pragma mark -- 公告
- (instancetype)initNoticeDataSource;

#pragma mark --
#pragma mark -- 银行卡
/** 获取用户绑定银行卡列表 */
- (instancetype)initBankCardList;

/** 根据银行卡号码识别对应银行 */
- (instancetype)initGetBankNameWithPreBankCardNum:(NSString *)bankNum;

/**
 (添加银行卡
 
 @param account_type 账户类型(1为个人 2为公司)
 @param account_name 银行开户名
 @param account_number [银行帐号
 @param bank_type_name 开户银行名称
 @param branch 开户行支行
 @param mobile 手机号码
 @return 请求操作类
 */
- (instancetype)initAddNewBankCardWithAccountType:(NSString *)account_type
                                     account_name:(NSString *)account_name
                                   account_number:(NSString *)account_number bank_type_name:(NSString *)bank_type_name
                                           branch:(NSString *)branch
                                           mobile:(NSString *)mobile;

/**
 添加微信/支付宝收款码
 @param name 真实姓名
 @param codeType 微信1，支付宝2
 @param payNumber 微信/支付宝帐号
 @param img 收款码图片地址
 */
- (instancetype)initAddPaymentCodeWithName:(NSString *)name
                                  codeType:(NSString *)codeType
                                 payNumber:(NSString *)payNumber
                                       img:(NSString *)img;

/** 解绑银行卡操作 */
- (instancetype)initUnBankWithCardID:(NSString *)cardID;


#pragma mark --
#pragma mark -- 实名认证
/** 上传图片 */
- (instancetype)initUploadImage;

/**
 身份认证
 @param name 真实姓名
 @param idnumber 身份证号
 @param idcardimg 身份证照片拼接url
 @param isoverseas 海外认证
 @return api
 */
- (instancetype)initWithRealName:(NSString *)name
                        idnumber:(NSString *)idnumber
                       idcardimg:(NSString *)idcardimg
                     countrycode:(NSString *)countrycode
                             sex:(NSString *)sex
                      isoverseas:(BOOL)isoverseas;


#pragma mark --
#pragma mark -- 更新个人资料
- (instancetype)initChangeUserDataSourceWithNickName:(NSString *)name
                                                 sex:(NSString *)sex
                                           headerpic:(NSString *)pic
                                            borndate:(NSString *)borndate
                                                area:(NSString *)area
                                            areaCode:(NSString *)areaCode;

@end

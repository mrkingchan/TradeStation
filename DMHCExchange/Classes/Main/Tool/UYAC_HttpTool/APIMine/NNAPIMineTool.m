//
//  NNAPIMineTool.m
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/27.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNAPIMineTool.h"

@implementation NNAPIMineTool

- (instancetype)initMemberDataSource
{
    self = [super init];
    if (self) {
        self.requestReServiceType = NNH_API_User_Index;
        self.reAPIName = @"会员中心";
    }
    return self;
}

- (instancetype)initMyQrCode
{
    self = [super init];
    if (self) {
        self.requestReServiceType = NNH_API_User_Mycode;
        self.reAPIName = @"我的二维码";
    }
    return self;
}

- (instancetype)initAbout
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"user.index.about";
        self.reAPIName = @"关于我们";
    }
    return self;
}

- (instancetype)initVersionUpdate
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"sys.index.versionupdate";
        self.reAPIName = @"版本更新";
        
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        self.reParams = @{@"version" : currentVersion};
    }
    return self;
}

- (instancetype)initBrokerageWithPage:(NSUInteger)page
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"user.index.brokerage";
        self.reAPIName = @"返佣记录";
        self.reParams = @{@"page" : [NSString stringWithFormat:@"%zd",page]};
    }
    return self;
}

- (instancetype)initNoticeDataSource
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"index.index.announcementlist";
        self.reAPIName = @"交易所公告列表";
    }
    return self;
}

/** 获取用户绑定银行卡列表 */
- (instancetype)initBankCardList
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"user.user.banklist";
        self.reAPIName = @"获取用户绑定银行卡列表";
    }
    return self;
}

/** 根据银行卡号码识别对应银行 */
- (instancetype)initGetBankNameWithPreBankCardNum:(NSString *)bankNum
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"user.user.checkBankNumber";
        self.reAPIName = @"根据银行卡号码识别对应银行";
        self.reParams = @{
                          @"account_number"   : bankNum,
                          };
    }
    return self;
}

- (instancetype)initAddNewBankCardWithAccountType:(NSString *)account_type
                                     account_name:(NSString *)account_name
                                   account_number:(NSString *)account_number
                                   bank_type_name:(NSString *)bank_type_name
                                           branch:(NSString *)branch
                                           mobile:(NSString *)mobile
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"user.user.addbank";
        self.reAPIName = @"添加银行卡";
        self.reParams = @{
                          @"account_type"   : account_type,
                          @"account_name"   : account_name,
                          @"account_number" : account_number,
                          @"bank_type_name" : bank_type_name,
                          @"branch"         : branch,
                          @"mobile"         : mobile,
                          };
    }
    return self;
}

- (instancetype)initAddPaymentCodeWithName:(NSString *)name
                                  codeType:(NSString *)codeType
                                 payNumber:(NSString *)payNumber
                                       img:(NSString *)img
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"user.user.addpaybank";
        self.reAPIName = @"添加微信/支付宝收款码";
        
        self.reParams = @{
                          @"account_name" : name,
                          @"type" : codeType,
                          @"account_number" : payNumber,
                          @"img" : img
                          };
    }
    return self;
}

/** 解绑银行卡操作 */
- (instancetype)initUnBankWithCardID:(NSString *)cardID
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"user.user.unband";
        self.reAPIName = @"解绑银行卡";
        self.reParams = @{
                          @"bank_id"   : cardID,
                          };
    }
    return self;
}

- (instancetype)initUploadImage
{
    self = [super init];
    if (self) {
        self.requestReServiceType = @"sys.upload.policy";
        self.reAPIName = @"上传图片";
    }
    return self;
}

- (instancetype)initWithRealName:(NSString *)name
                        idnumber:(NSString *)idnumber
                       idcardimg:(NSString *)idcardimg
                     countrycode:(NSString *)countrycode
                             sex:(NSString *)sex
                      isoverseas:(BOOL)isoverseas
{
    self = [super init];
    if (self) {
        self.reAPIName = @"实名认证";
        if (isoverseas) {
            self.requestReServiceType = @"user.user.abroadauth";
            self.reParams = @{
                                  @"realname"    : name,
                                  @"idnumber"    : idnumber,
                                  @"idcardimg"   : idcardimg,
                                  @"countrycode" : countrycode,
                                  @"sex"         : sex
                              };
        }else {
            self.requestReServiceType = @"user.user.auth";
            self.reParams = @{
                                  @"realname"   : name,
                                  @"idnumber"   : idnumber,
                                  @"idcardimg"  : idcardimg
                              };
        }
    }
    return self;
}

- (instancetype)initChangeUserDataSourceWithNickName:(NSString *)name
                                                 sex:(NSString *)sex
                                           headerpic:(NSString *)pic
                                            borndate:(NSString *)borndate
                                                area:(NSString *)area
                                            areaCode:(NSString *)areaCode
{
    self = [super init];
    if (self) {
        self.requestReServiceType = NNH_API_User_UpdateInfo;
        self.reAPIName = @"修改我的资料";
        
        if (![NSString isEmptyString:name]) {
            self.reParams = @{@"nickname" : name};
        }
        
        if (![NSString isEmptyString:sex]) {
            self.reParams = @{@"sex" : sex};
        }
        
        if (![NSString isEmptyString:pic]) {
            self.reParams = @{@"headerpic" : pic};
        }
        
        if (![NSString isEmptyString:borndate]) {
            self.reParams = @{@"borndate" : borndate};
        }
        
        if (![NSString isEmptyString:areaCode]) {
            self.reParams = @{@"area" : area, @"area_code" :areaCode};
        }
    }
    
    return self;
}

@end

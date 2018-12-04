//
//  NNHApiWalletTool.h
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/27.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           用户钱包模块 接口
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import "NNHBaseRequest.h"


@interface NNHApiWalletTool : NNHBaseRequest


/**
 获取钱包首页列表数据

 @return api
 */
- (instancetype)initWithWalletListDataWithKeyword:(NSString *)keyword;


/**
 币种充值

 @param coinID 币种id
 @return api
 */
- (instancetype)initWithCoinRechargeAddressDataWithCoinID:(NSString *)coinID;


/**
 币种提现信息
 
 @param coinID 币种id
 @return api
 */
- (instancetype)initWithCoinWithdrawDataWithCoinID:(NSString *)coinID;


/**
 币种提现操作

 @param coinID 币种id
 @param num 数量
 @param paypassword 支付密码
 @param moble_verify 手机验证码
 @param address 地址
 @param memo 标签
 @return api
 */
- (instancetype)initWithCoinWithdrawActionWithCoinID:(NSString *)coinID
                                                 num:(NSString *)num
                                         paypassword:(NSString *)paypassword
                                        moble_verify:(NSString *)moble_verify
                                             address:(NSString *)address
                                                memo:(NSString *)memo;


/**
 币种账单

 @param coinID 币种id
 @param type 操作类型
 @param page 页码
 @return api
 */
- (instancetype)initWithCoinTransferListDataWithCoinID:(NSString *)coinID type:(NSString *)type page:(NSInteger)page;

@end

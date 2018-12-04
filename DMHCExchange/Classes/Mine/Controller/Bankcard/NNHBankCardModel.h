//
//  NNHBankCardModel.h
//  NNCivetCat
//
//  Created by 来旭磊 on 17/3/30.
//  Copyright © 2017年 灵猫. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NNHBankConfigModel;

@interface NNHBankCardModel : NSObject
/** id */
@property (nonatomic, copy) NSString *cardID;
/** 类型 1个人， 2公司 */
@property (nonatomic, copy) NSString *cardType;
/** 户名 */
@property (nonatomic, copy) NSString *cardUserName;
/** 开户行名称 */
@property (nonatomic, copy) NSString *cardBankName;
/** 开户行支行 */
@property (nonatomic, copy) NSString *cardBankSubName;
/** 预留手机号 */
@property (nonatomic, copy) NSString *cardMobile;
/** 银行卡号 */
@property (nonatomic, copy) NSString *cardNum;
/** 背景渐变色 */
@property (nonatomic, strong) UIColor *backColor;
/** 尾号 */
@property (nonatomic, copy) NSString *tailNumber;

@end

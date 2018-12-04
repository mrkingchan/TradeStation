//
//  NNSecurityVerifyViewController.h
//  DMHCExchange
//
//  Created by 牛牛 on 2018/10/25.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNSecurityVerifyViewController : UIViewController

/**
 初始化控制器对象
 
 @param securityVerifyType 验证方式
 @param verificationCodeType 验证码类型
 @return 实例对象
 */
- (instancetype)initWithSecurityVerifyType:(NNSecurityVerifyType)securityVerifyType
                      verificationCodeType:(NNHSendVerificationCodeType)verificationCodeType;

@end

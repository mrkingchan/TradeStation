//
//  NNHVerifyPhoneViewController.h
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/7.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           验证手机
 
 @Remarks          <#注释#>
 
 *****************************************************/

#import <UIKit/UIKit.h>

@interface NNVerifyPhoneViewController : UIViewController

/**
 初始化控制器对象
 
 @param type 发送验证码类型
 @return 实例对象
 */
- (instancetype)initWithType:(NNHSendVerificationCodeType)type;

@end

//
//  NNSetPhoneViewController.h
//  YWL
//
//  Created by 牛牛 on 2018/7/16.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNSetupPhoneViewController : UIViewController

/** 加密串 */
@property (nonatomic, copy) NSString *encrypt;
/** 验证方式 */
@property (nonatomic, assign) NNSecurityVerifyType securityVerifyType;

@end

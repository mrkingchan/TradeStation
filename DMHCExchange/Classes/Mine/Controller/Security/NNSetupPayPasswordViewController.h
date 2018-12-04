//
//  NNSetupPayPasswordViewController.h
//  SuperWallet
//
//  Created by 来旭磊 on 2018/3/7.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

@interface NNSetupPayPasswordViewController : UIViewController

/** 加密串 */
@property (nonatomic, copy) NSString *encrypt;
/** 验证方式 */
@property (nonatomic, assign) NNSecurityVerifyType securityVerifyType;

@end

//
//  NNLoginSecurityVerifyViewController.h
//  DMHCExchange
//
//  Created by 牛牛 on 2018/10/25.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNLoginSecurityVerifyViewController : UIViewController

/** 安全校验接口 需要传递的信息 */
@property (nonatomic, copy) NSString *username;
/** 安全校验接口加密码 */
@property (nonatomic, copy) NSString *cryptcode;
/** 验证成功block */
@property (nonatomic, copy) void(^verifySuccessBlock)(void);

@end

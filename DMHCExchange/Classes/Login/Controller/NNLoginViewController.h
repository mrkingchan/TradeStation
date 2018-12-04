//
//  NNHLoginViewController.h
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/6.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completionBlock)(void);

@interface NNLoginViewController : UIViewController

/** 登录成功block */
@property (nonatomic, copy) completionBlock loginSuccessBlock;

// 类方法初始化，方便调用吧~
+ (instancetype)presentInViewController:(UIViewController *)vc completion:(completionBlock)block;

- (void)dismissVC;

@end

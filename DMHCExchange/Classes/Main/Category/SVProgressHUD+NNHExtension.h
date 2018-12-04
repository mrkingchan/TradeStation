//
//  SVProgressHUD+NNHExtension.h
//  ElegantTrade
//
//  Created by 来旭磊 on 16/11/3.
//  Copyright © 2016年 牛牛汇. All rights reserved.
//

#import "SVProgressHUD.h"

@interface SVProgressHUD (NNHExtension)

///** 提示状态 */
+ (void)nn_showWithStatus:(NSString*)status;

/** 提示信息 */
+ (void)showMessage:(NSString *)message;

///** 关闭提示 */
+ (void)nn_dismiss;
+ (void)nn_dismissWithCompletion:(SVProgressHUDDismissCompletion)completion;
+ (void)nn_dismissWithDelay:(NSTimeInterval)delay;
+ (void)nn_dismissWithDelay:(NSTimeInterval)delay completion:(SVProgressHUDDismissCompletion)completion;


@end

//
//  NNLegalTenderTradeOrderDetailPHelper.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/31.
//  Copyright © 2018 超级钱包. All rights reserved.
//

/*****************************************************
 
 @Author             来旭磊
 
 @CreateTime      TimeForever
 
 @ function           法币交易 成交订单 辅助类
 
 @Remarks          vc
 
 *****************************************************/

#import <Foundation/Foundation.h>
@class NNLegalTenderTradeOrderDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface NNLegalTenderTradeOrderDetailHelper : NSObject

/** 操作回调block */
@property (nonatomic, copy) void(^reloadDataBlock)(void);

/** 当前显示控制器 */
@property (nonatomic, weak) UIViewController *currentViewController;

/** 订单模型 */
@property (nonatomic, strong) NNLegalTenderTradeOrderDetailModel *orderModel;

/** 上传凭证 */
- (void)uploadOrderCertificateWithImageView:(UIImageView *)scanImageView;

/** 查看凭证 */
- (void)scanOrderCertificateWithImageView:(UIImageView *)scanImageView;

/** 查看收款码 */
- (void)scanPictureWithUrl:(NSString *)url fromImageView:(UIImageView *)imageView;

/** 联系对方 */
- (void)contactTheCuonsumer;

/** 底部按钮操作 */
- (void)operationViewAction;

/** 取消订单或我要申诉 */
- (void)rightItemAction;

@end

NS_ASSUME_NONNULL_END

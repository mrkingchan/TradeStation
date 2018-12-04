//
//  NNKLineViewController.h
//  DMHCExchange
//
//  Created by 云笈 on 2018/10/26.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NNCoinTradingMarketModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NNKLineViewController : UIViewController

@property (nonatomic, strong) NNCoinTradingMarketModel *model;
/** 返回卖出交易区 */
@property (nonatomic, copy) void (^backSaleTradingBlock) (void);

@end

NS_ASSUME_NONNULL_END

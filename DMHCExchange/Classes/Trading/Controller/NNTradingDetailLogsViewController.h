//
//  NNTradingDetailLogsViewController.h
//  SuperWallet
//
//  Created by 牛牛 on 2018/8/15.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NNTradingEntrustModel;

@interface NNTradingDetailLogsViewController : UIViewController

/**
 初始化
 
 @return 控制器对象
 */
- (instancetype)initWithCoinTradingDetailModel:(NNTradingEntrustModel *)model;

@end

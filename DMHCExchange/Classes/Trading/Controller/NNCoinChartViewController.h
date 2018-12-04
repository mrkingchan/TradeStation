//
//  NNCoinChartViewController.h
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/28.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NNHCoinPriceModel;

@interface NNCoinChartViewController : UIViewController

- (instancetype)initWithCoinID:(NSString *)coinID;

/**  */
@property (nonatomic, copy) void(^getExchangeIndexBlock)(NSInteger index);

@end

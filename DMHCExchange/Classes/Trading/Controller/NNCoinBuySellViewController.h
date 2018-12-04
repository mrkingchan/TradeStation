//
//  NNCoinBuySellViewController.h
//  SuperWallet
//
//  Created by 牛牛 on 2018/3/31.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import "NNExchangeChildViewController.h"
#import "NNCoinTradingMarketModel.h"

@interface NNCoinBuySellViewController : NNExchangeChildViewController

- (instancetype)initWithCoinTradingType:(NNHCoinTradingOrderType)type
                 coinTradingMarketModel:(NNCoinTradingMarketModel *)model;

@end

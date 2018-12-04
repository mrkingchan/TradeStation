//
//  NNCoinBuySellListView.h
//  SuperWallet
//
//  Created by 牛牛 on 2018/4/16.
//  Copyright © 2018年 Smile intl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNCoinBuySellListView : UIView

/* 买 */
@property (nonatomic, strong, readwrite) NSArray *buyLists;
/* 卖 */
@property (nonatomic, strong, readwrite) NSArray *sellLists;
/** 当前价格 */
@property (nonatomic, strong, readwrite) NSString *currentPrice;
/** 选中数量 */
@property (nonatomic, copy) void (^selectedPriceBlock)(NSString *price);

- (instancetype)initWithLeftUnit:(NSString *)leftUnit rightUnit:(NSString *)rightUnit;

@end

//
//  NNHWalletTableHeaderView.h
//  DMHCExchange
//
//  Created by 牛牛汇 on 2018/10/24.
//  Copyright © 2018 超级钱包. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNHWalletTableHeaderView : UIView

@property (nonatomic, copy) void (^searchTextBlock)(NSString *searchText);

/**
 显示总金额及单位

 @param amount 总金额
 @param amountUnit 单位
 */
- (void)configAmount:(NSString *)amount amountUnit:(NSString *)amountUnit;

@end

NS_ASSUME_NONNULL_END

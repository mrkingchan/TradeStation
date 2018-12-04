//
//  NNHRegisterAreaView.h
//  WBTWallet
//
//  Created by 牛牛 on 2018/3/6.
//  Copyright © 2018年 深圳市云牛惠科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NNHCountryCodeModel;

@interface NNRegisterAreaView : UIView

/** 数据源 */
@property (nonatomic, strong) NSMutableArray <NNHCountryCodeModel *>*dataSource;

/** 当前选种的数据源数组 */
@property (nonatomic, strong) NNHCountryCodeModel *selectedModel;

/** 点击选择回调 */
@property (nonatomic, copy) void(^selectedCodeBlock)(NNHCountryCodeModel *countryCode);

@end

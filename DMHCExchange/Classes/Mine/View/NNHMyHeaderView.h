//
//  NNHMyHeaderView.h
//  ElegantTrade
//
//  Created by 牛牛 on 16/10/23.
//  Copyright © 2016年 牛牛汇. All rights reserved.
//

typedef NS_ENUM(NSInteger, NNHMyHeaderViewJumpType) {
    NNHMyHeaderViewJumpTypeRealName = 0,    // 跳转实名
    NNHMyHeaderViewJumpTypeLogin = 1,    // 跳转登录
    NNHMyHeaderViewJumpTypeInformation = 2,    // 个人资料
};

#import <UIKit/UIKit.h>
@class NNMineModel;

@interface NNHMyHeaderView : UIImageView

@property (nonatomic, strong) NNMineModel *mineModel;
@property (nonatomic, copy) void (^headerViewJumpBlock)(NNHMyHeaderViewJumpType type);

@end

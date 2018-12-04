//
//  NNPriceVolumeView.h
//  DMHCExchange
//
//  Created by 云笈 on 2018/11/7.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Y_KLineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NNPriceVolumeView : UIView

- (void)refreshWithModel:(Y_KLineModel *)model;

@end

NS_ASSUME_NONNULL_END

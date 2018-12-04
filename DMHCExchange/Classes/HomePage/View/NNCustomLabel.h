//
//  NNCustomLabel.h
//  DMHCExchange
//
//  Created by 云笈 on 2018/11/8.
//  Copyright © 2018年 超级钱包. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // 垂直对其方式
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

NS_ASSUME_NONNULL_BEGIN


/**
 主要用于画UILabel的垂直对齐方式
 */
@interface NNCustomLabel : UILabel

@property (nonatomic) VerticalAlignment verticalAlignment;

@end

NS_ASSUME_NONNULL_END
